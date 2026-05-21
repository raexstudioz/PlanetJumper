extends Node2D

@export var initial_state : State
@export var GameManager : Node2D
@export var difficulty_interval : float = 60.0

var current_state : State
var states: Dictionary = {}
var difficulty_timer : Timer

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

	difficulty_timer = Timer.new()
	difficulty_timer.wait_time = difficulty_interval
	difficulty_timer.one_shot = false
	difficulty_timer.timeout.connect(Go_Next_Difficulty)
	add_child(difficulty_timer)
	difficulty_timer.start()

	if GameManager:
		GameManager.GameIsOver.connect(_on_game_over)

func _on_game_over():
	difficulty_timer.stop()

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		difficulty_timer.stop() # reached last state, no more transitions
		return
	if current_state:
		current_state.Exit()

	new_state.Enter()
	current_state = new_state

func Go_Next_Difficulty():
	current_state.GoNext()
