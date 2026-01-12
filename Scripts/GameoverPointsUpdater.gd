extends Control

@export var PointText : RichTextLabel
@export var ScoreText : RichTextLabel

@export var OGPoints : RichTextLabel
@export var OGScore : RichTextLabel

func update_score():
	ScoreText.text = OGScore.text
	print("OG Score: ", OGScore.text)
	
func update_points():
	PointText.text = OGPoints.text
	print("OG Points: ", OGPoints.text)
	
func update():
	update_points()
	update_score()
	print("Update on Gameover Ran")
	
func _ready() -> void:
	visibility_changed.connect(update)
