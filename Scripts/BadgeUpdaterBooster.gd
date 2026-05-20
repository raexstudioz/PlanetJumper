extends TextureRect

@export var PointsLabel : RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.boosterUpdated.connect(BoosterUpdater)
	await get_tree().create_timer(1.0).timeout
	BoosterUpdater()



func BoosterUpdater():
	print("Boosters have been updated!! " + str(GlobalVariables.Boosters))
	PointsLabel.text = "[center]" + str(GlobalVariables.Boosters) + "[/center]"
	
