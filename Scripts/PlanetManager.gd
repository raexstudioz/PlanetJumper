extends Node2D

# Preload your planets (PackedScene)
var planet_scenes = [
	preload("res://Scenes/Planet1.tscn"),
	preload("res://Scenes/Planet2.tscn"),
	preload("res://Scenes/Planet3.tscn")
]
@export var game_Manager : Node2D
# Pool dictionary to store inactive planets
var object_pool: Dictionary = {}


# Probability list, e.g., 50% chance for Planet1, 30% for Planet2, 20% for Planet3
var spawn_probabilities = [0.5, 0.3, 0.2]

# The pool size for each planet type (in this case, 10)
var pool_size = 10

func _ready():
	# Initialize pool with a size of 10 for each planet type
	for i in range(planet_scenes.size()):
		object_pool[i] = []
		for j in range(pool_size):
			var planet_instance = planet_scenes[i].instantiate()
			planet_instance.hide()  # Hide initially
			add_child(planet_instance)  # Add the instance to the scene tree
			planet_instance.Initialize()
			object_pool[i].append(planet_instance)  # Store in the pool

	# Begin the spawn process with randomized gaps
	spawn_planet()
	add_child(spawn_timer)
	spawn_timer.set_one_shot(true)
	spawn_timer.connect("timeout", _on_spawn_timeout)
	start_spawning()

# Function to get a random planet type based on probability
func get_random_planet_type() -> int:
	var rand = randf()
	var cumulative_prob = 0.0
	for i in range(spawn_probabilities.size()):
		cumulative_prob += spawn_probabilities[i]
		if rand < cumulative_prob:
			return i
	return spawn_probabilities.size() - 1
var gap = 0
# Function to spawn planets
func spawn_planet():
	var planet_type = get_random_planet_type()
	var planet = get_from_pool(planet_type)
	print("Planet Type: ", planet_type)
	var gap_percentage = 10
	var screen_size = get_viewport_rect().size
	if planet:
		if(planet_type == 0):
			planet.global_position = Vector2(randf_range(-420,420), randf_range(-(screen_size.y/gap_percentage) - 200 - gap,-(screen_size.y/gap_percentage)- 400 - gap)) # Randomize the spawn position
		elif(planet_type == 1 || planet_type == 2):
			planet.global_position = Vector2(randf_range(-370,370), randf_range(-(screen_size.y/gap_percentage) - 200 - gap,-(screen_size.y/gap_percentage)- 400 - gap)) # Randomize the spawn position
		planet.show()  # Make the planet visible
		gap+=400

# Retrieve a planet from the pool (recycle)
func get_from_pool(planet_type: int) -> Node2D:
	for planet in object_pool[planet_type]:
		if not planet.visible:  # If it's hidden (inactive)
			return planet
	return null  # If no inactive planet is available

# Randomized spawning intervals using a timer
var spawn_timer = Timer.new()


# Start the spawning process
func start_spawning():
	_on_spawn_timeout()  # Start immediately

func _on_spawn_timeout():
	spawn_planet()  # Spawn a new planet
	spawn_timer.set_wait_time(randf_range(1.0, 3.0))  # Set next random delay (1 to 3 seconds)
	spawn_timer.start()  # Restart the timer

func set_spawn_probabilities(probs: Array):
	spawn_probabilities = probs
