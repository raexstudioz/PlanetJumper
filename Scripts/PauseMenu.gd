extends Node

#var gameManager
@export var musicstream : TextureProgressBar
@export var sfxstream : TextureProgressBar
@export var gameManager : Node2D

signal submusic(volume : float)
signal addmusic(volume : float)
signal subsfx(volume : float)
signal addsfx(volume : float)

func _ready() -> void:
	#gameManager = get_node("../")
	hide_subMenu()
	init_volume()
	
func show_pauseMenu(menuType : String):
	get_node(".").visible = true
	show_subMenu(menuType)
	print("Current scene name: " + get_tree().current_scene.name)
	if(get_tree().current_scene.name == "Game"):
		gameManager.pause_game()

func hide_pauseMenu():
	get_node(".").visible = false
	hide_subMenu()
	if(get_tree().current_scene.name == "Game"):
		gameManager.pause_game()

func show_subMenu(menuType: String):
	match menuType:
		"NotEnoughCoins":
			$"Not Enough Coins".visible = true
		"SettingsMenu":
			init_volume()
			$"Settings Menu".visible = true
	pass
	
func init_volume():
	musicstream.value = GlobalVariables.MusicVolume * 100
	sfxstream.value = GlobalVariables.SFXVolume * 100

func hide_subMenu():
	$"Not Enough Coins".visible = false
	$"Settings Menu".visible = false
	
func subtract_musicvolume():
	musicstream.value = musicstream.value - 10
	submusic.emit(musicstream.value/100)
	

func add_musicvolume():
	musicstream.value = musicstream.value + 10
	addmusic.emit(musicstream.value/100)
	
func subtract_sfxvolume():
	sfxstream.value = sfxstream.value - 10
	subsfx.emit(sfxstream.value/100)
	
func add_sfxvolume():
	sfxstream.value = sfxstream.value + 10
	addsfx.emit(sfxstream.value/100)
