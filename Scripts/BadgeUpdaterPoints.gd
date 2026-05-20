extends TextureRect

@export var PointsLabel : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.pointsUpdated.connect(pointsUpdater)
	await get_tree().create_timer(1.0).timeout
	pointsUpdater()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pointsUpdater():
	print("Points have been updated!! " + str(GlobalVariables.globalpoints))
	PointsLabel.text = "[center]" + str(GlobalVariables.globalpoints) + "[/center]"
