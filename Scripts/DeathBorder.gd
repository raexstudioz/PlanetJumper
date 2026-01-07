extends Area2D

@export var x : int
@export var thickness := 100.0


func _ready() -> void:
	resize_wall()
	
func resize_wall():
	var size = get_viewport_rect().size
	#Top
	if(x == 1):
		position = Vector2(size.x/2, -thickness/2 )
	#Bottom
	if(x == 2):
		position = Vector2(size.x/2, size.y + thickness/2)
		
	#Left
	if(x == 3):
		position = Vector2(-thickness/2, size.y/ 2)
		
	#Right
	if(x == 4):
		position = Vector2(size.x + thickness, size.y/2)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("spaceships"):
		pass
		#get_node("../../").GameOver()
