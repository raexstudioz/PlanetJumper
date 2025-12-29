extends Area2D
var speed = 100
var rotation_speed = 100
@export var explosion : GPUParticles2D
@export var camera : Node2D

	
	
	#linear_velocity = Vector2(0,speed)
	#set_angular_velocity(10)

func _process(delta):
	position.y += speed * delta
	rotation_degrees += rotation_speed * delta

func on_spaceship_exit(body : Node):
	if body.is_in_group("spaceships"):
		DestroyEarth()
		
		
func DestroyEarth():

	await get_tree().create_timer(1.0).timeout
	$Sprite2D.visible = false
	explosion.emitting = true
	camera.shake(.5,15,8)
	await get_tree().create_timer(1.0).timeout
	self.visible = false
