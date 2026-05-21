extends RichTextLabel


# Variable to store the time elapsed
var time_elapsed : float = 0.0
@export var game_manager : Node2D
@export var FirebaseManager : Node2D
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

func AddHighScore():
	if(int(time_elapsed) > GlobalVariables.HighScore):
		GlobalVariables.HighScore = int(time_elapsed)
		var type = SavingTypeList.new()
		type.type_list["HighScore"] = true
		SaveAndLoad.Save_PlayerData(type)
		FirebaseManager.fetch_my_score()
		
	
