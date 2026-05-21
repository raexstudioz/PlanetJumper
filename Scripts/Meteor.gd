extends Node2D

var gameManager : Node2D
var side = false
var is_active = false
var spaceship : Node2D
var speed : float = 100

func _ready():
	gameManager = get_node("../../")
	destroy_meteor()

func _process(delta):
	if(gameManager.game_is_over): return
	
	if(side==false):
		position.x -= speed * delta
	else:
		position.x += speed * delta

func _on_area_2d_body_entered(body):
	if body.is_in_group("spaceships"):
		spaceship = body
		if !body.shield_On:
			spaceship.DeductLife()
			destroy_meteor()
		else:
			destroy_meteor()

func destroy_meteor():
	is_active = false
	self.hide()
	position.y = -2000
	position.x = -2000
	get_node("../").send_meteorBackToPool(self)
	
	
func initialize():
	is_active = true
	self.show()
	var x = randf_range(0,2)
	if(int(x)==0):
		side = true
		spawn_left()
		
	elif(int(x)==1):
		side = false
		spawn_right()
		
func spawn_left():
	position.y = randf_range(-800,800)
	position.x = randf_range(-1090,-1100)
	
func spawn_right():
	position.y = randf_range(-800,800)
	position.x = randf_range(1090,1100)
	
