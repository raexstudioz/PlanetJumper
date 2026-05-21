extends Node

var globalpoints : int
var HighScore : int
var Shield_Time : int
var ShieldCount : int
var Boosters : int
var SFXVolume : float
var MusicVolume : float
var LastPointsDate : String = ""

func add_point():
	globalpoints = 1 + globalpoints
	notifyPointsUpdate()
	
func add_custom_points(points: int):
	globalpoints = globalpoints + points
	notifyPointsUpdate()

func deduct_point(points_to_deduct:int):
	print("Points to deduct!!")
	globalpoints = globalpoints - points_to_deduct
	notifyPointsUpdate()

func add_ShieldTime():
	Shield_Time = Shield_Time + 1
	notifyShieldUpdate()

func deduct_ShieldTime():
	Shield_Time = Shield_Time - 1
	print("Deducting Shield Time:",Shield_Time)
	notifyShieldUpdate()
	
func add_Boosters():
	Boosters = Boosters + 1
	notifyBoosterUpdate()

func deduct_Boosters():
	Boosters = Boosters - 1
	notifyBoosterUpdate()
	
func change_SFX(volume : float):
	SFXVolume = volume
	
func change_music(volume : float):
	MusicVolume = volume
	
signal pointsUpdated
signal shieldUpdated
signal boosterUpdated

func notifyPointsUpdate():
	pointsUpdated.emit()
	
func notifyShieldUpdate():
	shieldUpdated.emit()
	
func notifyBoosterUpdate():
	boosterUpdated.emit()
