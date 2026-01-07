extends RichTextLabel


# Variable to store the time elapsed
var time_elapsed : float = 0.0
@export var game_manager : Node2D
var Difficulty1 = false
var Difficulty2 = false
var Difficulty3 = false
var Difficulty4 = false
@export var DifficultyLimit1 = 6
@export var DifficultyLimit2 = 12
@export var DifficultyLimit3 = 18
@export var DifficultyLimit4 = 22
@export var FirebaseManager : Node2D
@export var StateManager : Node2D
# Called when the node enters the scene tree for the first time
func _ready():
	# Initialize the time_elapsed variable
	time_elapsed = 0.0
	# Set the initial text of the label to "Time elapsed: 0"
	text = "Score: 0"
	#game_manager = get_node("../../../")
	game_manager.connect("GameIsOver", AddHighScore)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_manager.game_is_over : return
	# Update the time_elapsed variable
	time_elapsed += delta
	# Update the label text with the time elapsed as an integer
	text = "Score: " + str(int(time_elapsed))
	DifficultyChange()
	#AddHighScore()
		
func DifficultyChange():
		if(int(time_elapsed)==DifficultyLimit1 && Difficulty1==false):
			StateManager.Go_Next_Difficulty()
			Difficulty1 = true
		elif(int(time_elapsed)==DifficultyLimit2 && Difficulty2==false):
			StateManager.Go_Next_Difficulty()
			Difficulty2 = true
		elif(int(time_elapsed)==DifficultyLimit3 && Difficulty3==false):
			StateManager.Go_Next_Difficulty()
			Difficulty3 = true
		elif(int(time_elapsed)==DifficultyLimit4 && Difficulty4==false):
			StateManager.Go_Next_Difficulty()
			Difficulty3 = true

func AddHighScore():
	if(int(time_elapsed) > GlobalVariables.HighScore):
		GlobalVariables.HighScore = int(time_elapsed)
		var type = SavingTypeList.new()
		type.type_list["HighScore"] = true
		SaveAndLoad.Save_PlayerData(type)
		FirebaseManager.fetch_my_score()
		
	
