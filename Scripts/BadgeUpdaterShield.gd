extends TextureRect

@export var PointsLabel : RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.shieldUpdated.connect(ShieldUpdater)
	await get_tree().create_timer(1.0).timeout
	ShieldUpdater()
	
func ShieldUpdater():
	print("Shield have been updated!! " + str(GlobalVariables.Shield_Time))
	PointsLabel.text = "[center]" + str(GlobalVariables.Shield_Time) + "[/center]"
