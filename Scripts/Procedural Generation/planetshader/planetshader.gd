extends Sprite2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mat
var val = 10.0
var randomColor : colorclass
# Called when the node enters the scene tree for the first time.
func _ready():
	mat = self.get_material()
	mat.set_shader_parameter("seed",randi() % 10000)

func randomize():
	print("Randomizing Colors of Planet!!")
	mat = self.get_material()
	mat.set_shader_parameter("seed",randi() % 10000)
	mat.set_shader_parameter("landmass", randf_range(1,1.2))
	mat.set_shader_parameter("density",randf_range(2,5.45))
	if randomColor:
		mat.set_shader_parameter("color_1",randomColor.color1)
		mat.set_shader_parameter("color_2",randomColor.color2)
		mat.set_shader_parameter("color_3",randomColor.color3)
		mat.set_shader_parameter("color_4",randomColor.color4)
		mat.set_shader_parameter("color_5",randomColor.color5)
		mat.set_shader_parameter("color_6",randomColor.color6)
		mat.set_shader_parameter("color_7",randomColor.color7)
		mat.set_shader_parameter("color_8",randomColor.color8)
		mat.set_shader_parameter("color_9",randomColor.color9)
		mat.set_shader_parameter("color_10",randomColor.color10)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(0.11*delta)
	
	#mat.set_shader_param("seed",val)
	#val += 0.01
