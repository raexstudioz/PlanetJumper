
extends Control

var firebase_url = "https://planetjumper-8af2b-default-rtdb.firebaseio.com/highscores.json"
@export var leaderboard_list : Control

func _ready() -> void:
	get_highest_score()
# Function to get the top 50 highest scores
func get_highest_score():
	var url = firebase_url + "?orderBy=\"score\"&limitToLast=50"  # Fetch bottom 50 (Firebase returns ascending)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	print("URL: ", url)
	http_request.request(url)
	http_request.request_completed.connect(_on_high_score_fetched)

# Function to handle the completion of the request
func _on_high_score_fetched(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse_string(body_string)

		if parse_result is Dictionary:
			var players = []
			for id in parse_result:
				var player_data = parse_result[id]
				players.append(player_data)

			# Sort by score descending
			players.sort_custom(_sort_by_score_desc)
			populate_leaderboard(players)
			# Print top players
			for player in players:
				print("Name: %s | Score: %d" % [player.get("name", "Unknown"), player.get("score", 0)])

		else:
			print("Error parsing JSON: ", parse_result)
	else:
		print("Error fetching high scores: ", response_code)
		
	

func _sort_by_score_desc(a, b) -> bool:
	return int(a["score"]) > int(b["score"])  # True = a comes before b

#@onready var leaderboard_list = $ScrollContainer/LeaderboardList

var row_scene = preload("res://Scenes/LeaderboardRow.tscn")  # adjust path if needed

func populate_leaderboard(players: Array):
	#leaderboard_list.clear()  # remove old rows

	for player in players:
		print("Instantiating!!")
		var row = row_scene.instantiate()
		row.get_node("NameLabel").text = player.get("name", "Unknown")
		row.get_node("ScoreLabel").text = str(player.get("score", 0))
		leaderboard_list.add_child(row)
		
func Close_Leaderboard():
	self.visible = false

func Open_Leaderboard():
	self.visible = true
