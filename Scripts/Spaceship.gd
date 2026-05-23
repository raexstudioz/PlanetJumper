extends CharacterBody2D

var on_planet = true
var current_planet = null
var speed = 200
var landed = false
var circle_position: Vector2
var circle_radius: float
var onEarth = true
var shield_On = false
var shield : Node2D
var original_speed = 200
var Boost_Speed = 900
var gameManager
var gameOver = false
var Life : int = 3

func _ready():
	current_planet = get_node(".").get_parent()
	gameManager = get_node("../../")
	gameManager.connect("BoostSpeed",BoostSpaceship)
	shield = $Shield
	deactivate_Shield()
	gameManager.connect("GameIsOver", set_gameOver)
	gameManager.connect("LeavePlanet",_leave_current_planet)

func set_gameOver():
	gameOver = true
	
# Returns true if the tap/click landed on a UI Control
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Leaving Planet now")
		#_leave_current_planet()

func is_ui_control_at_position(pos: Vector2, group_name: String) -> bool:
	for node in get_tree().get_nodes_in_group(group_name):
		if node is Control:
			var rect: Rect2 = node.get_global_rect()
			if rect.has_point(pos):
				return true
	print("Returning False!!")
	return false
	
#Death Logic
@export var death_margin := 50.0 #how close to the edge
var dead := false
func _process(delta: float) -> void:
	if dead:
		return
	var cam:= get_viewport().get_camera_2d()
	var screen_size := get_viewport_rect().size
	var half := screen_size / 2.0

	var left := cam.global_position.x - half.x + death_margin
	var right := cam.global_position.x + half.x - death_margin
	var top := cam.global_position.y - half.y + death_margin
	var bottom := cam.global_position.y + half.y - death_margin

	var pos := global_position

	if on_planet:
		if pos.y >= bottom:
			trigger_game_over()
	else:
		if pos.x <= left or pos.x > right or pos.y <= top or pos.y >= bottom:
			trigger_game_over()
		
func trigger_game_over():
	dead = true
	print("GAME OVER!!")
	set_gameOver()
	gameManager.GameOver()
		
	
func _leave_current_planet():
	print("Leaving Current Planet!!")
	on_planet = false
	onEarth = false
	if current_planet:
		reparent(current_planet.get_parent())  # same as get_node(".").reparent(...)
		_startJetFuel()
	current_planet = null


func _physics_process(delta):
	if(gameOver): return
	if on_planet and current_planet:
		# Rotate with the planet
		
		#global_position = current_planet.global_position  +  current_planet.to_local(global_position).rotated(current_planet.angular_velocity * delta)
		if(landed):
			get_node(".").reparent(current_planet)
			#if(!onEarth):
				#position_tangent_to_circle()
			landed=false
		#current_planet.add_child(get_node("."))
	else:
		# Move upwards
		#velocity.y = -200
		var direction = Vector2(cos(rotation),sin(rotation))
		var rotated_direction = Vector2(-direction.y, direction.x)
		position -= rotated_direction * speed * delta
		#move_and_slide()

	  # Check for leaving the planet!
	#if Input.is_action_just_pressed("leave_planet") and on_planet and !is_touch_on_ui(get_viewport().get_mouse_position()):
		#on_planet = false
		#onEarth = false
		#if(current_planet!=null):
			#get_node(".").reparent(current_planet.get_parent())
			#_startJetFuel() #Starting Jet fuel when spaceship leaves the planet
		#current_planet = null
		
		



func _rotateby180():
	rotation_degrees = rotation_degrees + 180
	
func position_tangent_to_circle():
	var collision_point = global_position
	var tangent_point = collision_point + (collision_point - circle_position).normalized() * circle_radius
	global_position = tangent_point
	#_rotateby180()
	
func set_spaceship_position(pos : Vector2, rot : float):
	global_position = pos
	global_rotation = rot

#=======================Booster========================
signal startLaser
signal stopLaser

func BoostSpaceship():
	speed = Boost_Speed
	_startBoostedJetfuel()
	startLaser.emit()
	
func StopBoostSpaceship():
	speed = original_speed
	_stopJetFuel() #Stopping the jetfuel when landed
	_startNormalJetfuel() #setting jetfuel to normal
	stopLaser.emit()
#===========================================================
func activate_Shield():
	if(shield_On): return
	shield_On = true
	shield.visible = true
	var timer = $ShieldTimer
	print("Shield Time::" , GlobalVariables.Shield_Time)
	timer.wait_time = 2#GlobalVariables.Shield_Time
	print("Shield Timer: ", GlobalVariables.Shield_Time)
	GlobalVariables.deduct_ShieldTime()
	#New Code
	#region
	var type = SavingTypeList.new()
	type.type_list["ShieldTime"] = true
	SaveAndLoad.Save_PlayerData(type)
	#region end
	#New Code End
	timer.start()
	
	
func deactivate_Shield():
	shield_On = false
	shield.visible = false
	
#==================LIFE======================================
func DeductLife():
	Life -= 1
	print("Deducted Life!!:--", Life)
	gameManager.DeductTheLife()
	if Life <= 0:
		gameManager.GameOver()
		
#================JETFUEL====================================
signal startJetFuel
signal stopJetFuel
signal startNormalJetfuel
signal startBoostedJetfuel

func _startJetFuel():
	startJetFuel.emit()
	
func _stopJetFuel():
	stopJetFuel.emit()
	
func _startNormalJetfuel():
	startNormalJetfuel.emit()
	
func _startBoostedJetfuel():
	startBoostedJetfuel.emit()
