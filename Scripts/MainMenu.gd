extends Control

var firebase_url2 = "https://planetjumper-8af2b-default-rtdb.firebaseio.com/highscores/<uniqueID>.json"
var uniqueID

#========= Loading Data from files to GlobalData ========================
func _ready():
	uniqueID = OS.get_unique_id()
	get_tree().paused = false  #unpause when restarting game
	SaveAndLoad.Load_PlayerData()
	Refresh_Stored_Data()
	SaveAndLoad.DataIsSaving.connect(Refresh_Stored_Data)
	fetch_my_score()

func Refresh_Stored_Data():
	$Panel/ColorRect/PointLabel.text = str("Points: ",GlobalVariables.globalpoints)
	$Panel/ColorRect/HighScore.text = str("High Score: ", GlobalVariables.HighScore)
	if(SaveAndLoad.playerData.shieldTime!=null):
		print("Shield Time: ", SaveAndLoad.playerData.shieldTime)
		GlobalVariables.Shield_Time = SaveAndLoad.playerData.shieldTime
	else:
		print("There is no any shield Time!!")
		
	if(SaveAndLoad.playerData.Boosters!=null):
		print("The Booster: ", SaveAndLoad.playerData.Boosters)
		GlobalVariables.Boosters = SaveAndLoad.playerData.Boosters
	else:
		print("There is no any boosters!!")
	$Panel/ColorRect/"Booster Points".text = str("Booster Points: ",GlobalVariables.Boosters)
	if(SaveAndLoad.playerData.MusicVolume==null):
		GlobalVariables.MusicVolume = 1
	else:
		GlobalVariables.MusicVolume = SaveAndLoad.playerData.MusicVolume
		print("Global Music Volume!! - ", GlobalVariables.MusicVolume)
	if(SaveAndLoad.playerData.SFXVolume == null):
		GlobalVariables.SFXVolume = 1
	else:
		GlobalVariables.SFXVolume = SaveAndLoad.playerData.SFXVolume
		print("Global SFX Volume:-" , GlobalVariables.SFXVolume)

	
func start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	SaveAndLoad.DataIsSaving.disconnect(Refresh_Stored_Data)
	
#If points are mismatching from server then update it on server
func fetch_my_score():
	print("Fetching My Score!!")
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	#Construct the URL for the specified player
	var player_url = firebase_url2.replace("<uniqueID>",uniqueID)
	
	#Send HTTP GET request to firebase to fetch the player's score
	http_request.request(player_url)
	
	#Connect the signal for handling the response
	http_request.request_completed.connect(_on_my_score_fetched)
	
func _on_my_score_fetched(result:int, response_code:int, headers: Array, body: PackedByteArray):
	if(response_code==200):
		var body_string = body.get_string_from_utf8() #Conver body to string
		var json = JSON.new()
		print("Json Raw: ", body_string)
		var parse_result = json.parse_string(body_string)
		
		if parse_result is Dictionary:
			print("Parse Result is Dictionary. Score: " , parse_result["score"])
			if(parse_result["score"] < GlobalVariables.HighScore):
				print("THE HIGHSCORE IS NOT IN SYNC WITH SERVER!!!!")
				update_high_score(GlobalVariables.HighScore)
			
		else:
			print("Parse Result is not a Dict")
			#write_high_score("RaeX",GlobalVariables.HighScore)
			
			#var player_data = json.data
			#var score = player_data.get("score",null)
			#if(score!=null):
			#	print("Your Score: ", score)
			#else:
			#	print("Score not found for the player")
	else:
		print("Error fetching your score so Writing: ", response_code)
		
#Function to update the player's score in Firebase
func update_high_score(new_score: int):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var json_data = {
		"score": new_score
	}
	var headers = ["Content-Type: application/json"]
	var player_url = firebase_url2.replace("<uniqueID>",uniqueID)
	http_request.request(player_url,headers,HTTPClient.METHOD_PATCH,JSON.stringify(json_data))
	
	http_request.request_completed.connect(_on_score_updated)

func _on_score_updated(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if(response_code==200):
		print("Player Score Updated!!")
	else:
		print("Error updating player's score: " , response_code)
