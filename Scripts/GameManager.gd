extends Node2D

@export var falling_object_scene : PackedScene 
@export var timer : Timer
@export var GameOverScreen : Control
@export var PauseMenu : Control
var gap_percentage = 10

var planet_count = 0
var planet_points = 0

@export var point_label : RichTextLabel

#Global Variable
#--------------------
var planet_rotation_speed : float = 100
var downward_moving_speed : float = 100
var game_is_over = false
#--------------------


func _ready():
	var timer = get_node("Timer")
	timer.timeout.connect(_on_Timer_timeout)
	get_tree().paused = false #if restarting and the game is still paused
	#spawn_Planet() #------ Needed for Spawing the Planets -----#
	
func _on_Timer_timeout():
	pass
	
func spawn_Planet():
	var gap = 0
	for i in range(10):
		planet_count+=1
		var falling_object = falling_object_scene.instantiate()
		add_child(falling_object)
		var screen_size = get_viewport_rect().size
		falling_object.position = Vector2(randf_range(-450,450), randf_range(-(screen_size.y/gap_percentage) - 200 - gap,-(screen_size.y/gap_percentage)- 400 - gap))
		gap+=400
		


func add_point():
	LandPlanet()
	planet_points += 1
	point_label.text = str("Points: ",planet_points)
	GlobalVariables.add_point()
	var type = SavingTypeList.new()
	type.type_list["Points"] = true
	SaveAndLoad.Save_PlayerData(type)
	
func Use_Boosters():
	if(GlobalVariables.Boosters == 0):
		print("Not Enough Boosters To use!!")
		PauseMenu.show_pauseMenu("NotEnoughCoins")
		return
	
	print("Boosters USED!!")
	GlobalVariables.deduct_Boosters()
	var type = SavingTypeList.new()
	type.type_list["Points"] = true
	type.type_list["Boosters"] = true
	SaveAndLoad.Save_PlayerData(type)
	BoostSpeed.emit()

	
	
func Goto_MainMenu():
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
#SIGNALS
#============================
signal startingGame
signal pausingGame
signal stoppingGame
signal GameIsOver
signal settingSpeed
signal BoostSpeed
signal UIClicked
signal UIUnclikced
signal LeavePlanet
signal EnteredPlayArea
signal ExitPlayArea
signal LandedOnPlanet
signal DeductLife
signal MeteorHit
#============================
func DeductTheLife():
	DeductLife.emit()

func LandPlanet():
	LandedOnPlanet.emit()
	
func LeaveThePlanet():
	LeavePlanet.emit()

func UIClick():
	UIClicked.emit()

func UIUnclick():
	UIUnclikced.emit()

func start_game():
	startingGame.emit()
	
func set_speed(r_speed: float, d_speed : float):
	planet_rotation_speed = r_speed
	downward_moving_speed = d_speed
	settingSpeed.emit()

func stop_game():
	stoppingGame.emit()

func pause_game():
	pausingGame.emit()
	onPause()
	
func onPause():
	if get_tree().paused:
		get_tree().paused = false  # Unpause the game
	else:
		get_tree().paused = true  # Pause the game
	
func GameOver():
	print("Game Over!!")
	game_is_over = true
	GameOverScreen.visible = true
	pause_game()
	GameIsOver.emit()
	
func RestartGame():
	get_tree().reload_current_scene()
