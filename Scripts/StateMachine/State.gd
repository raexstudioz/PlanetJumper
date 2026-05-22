extends Node2D

class_name State

signal Transitioned
@export var next_state : String
@export var gameManager : Node2D
@export var r_speed : int
@export var d_speed : int
@export var MeteorManager : Node2D
@export var min_meteor_Timer : float
@export var max_meteor_Timer : float
@export var PlanetManager : Node2D
@export var spawn_probabilities : Array[float] = [1.0, 0.0, 0.0]
@export var meteor_speed : float = 100
@export var meteor_spawn_count : int = 1
@export var min_spawn_interval : float = 4.0
@export var max_spawn_interval : float = 5.0


func Enter():
	print("Entered:------->",self.name)
	gameManager.set_speed(r_speed, d_speed)
	MeteorManager.min_meteor_Timer = min_meteor_Timer
	MeteorManager.max_meteor_Timer = max_meteor_Timer
	MeteorManager.change_meteor_timer()
	MeteorManager.set_meteor_speed(meteor_speed)
	MeteorManager.spawn_count = meteor_spawn_count
	if PlanetManager:
		PlanetManager.set_spawn_probabilities(spawn_probabilities)
		PlanetManager.set_spawn_interval(min_spawn_interval, max_spawn_interval)
	pass

	
func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func GoNext():
	Transitioned.emit(self, next_state)
	
	
