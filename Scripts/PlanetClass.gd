extends Area2D
class_name Planets



var speed = 0
var screen_size
var rotation_speed = 0
var game_Manager : Node2D
var Planet_Manager : Node2D
var gameInitialized = false

@export var ResetPostion : bool
@export var thePlanet : Sprite2D


func Initialize():
	Planet_Manager = get_parent()
	game_Manager = Planet_Manager.game_Manager
	screen_size = get_viewport_rect().size
	position.y = randf_range(-800,-1200)
	position.x = randf_range(-10,10)
	set_speed()
	game_Manager.settingSpeed.connect(set_speed)
	gameInitialized = true
	randomizePlanet()

func _process(delta):
	if !gameInitialized: return
	if(game_Manager.game_is_over):
		return
	position.y += speed * delta
	rotation_degrees += rotation_speed * delta
	if (position.y > screen_size.y + 200 && !ResetPostion):
		reset_position()
	   

func reset_position():
	position.y = randf_range(-800,-1200)
	position.x = randf_range(-430,430)
	randomizePlanet()
	for child in get_children():
		if child.has_method("reset"):
			child.reset()

func change_rotation_values(downspeed: float,planet_rotation_speed : float):
	speed = downspeed
	rotation_speed = planet_rotation_speed
	pass
	
func set_speed():
	speed = game_Manager.downward_moving_speed
	rotation_speed = game_Manager.planet_rotation_speed

func randomizePlanet():
	if thePlanet:
		var color_nodes = Planet_Manager.get_children().filter(func(c): return c is colorclass)
		if color_nodes.size() > 0:
			thePlanet.randomColor = color_nodes[randi_range(0, color_nodes.size() - 1)]
		thePlanet.randomize()
