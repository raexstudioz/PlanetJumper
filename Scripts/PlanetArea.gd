extends Area2D

var body_has_entered = true
var Gamemanager
@export var spacesp : Node2D

func _ready() -> void:
	Gamemanager = get_node("../../../")

func _on_Area2D_body_entered(body):
	if body.is_in_group("spaceships"):
		if(body_has_entered):
			Gamemanager.add_point()
			body_has_entered = false
			body.StopBoostSpaceship()

		body.on_planet = true
		body.current_planet = get_parent()
		body.landed = true
		body.circle_position = global_position
		body.circle_radius = $CollisionShape2D.shape.radius
		body.set_spaceship_position(spacesp.global_position,spacesp.global_rotation)

func reset():
	body_has_entered = true
