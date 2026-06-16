extends Node
class_name StateMachine

@export var initial_state: NodePath

var states: Dictionary = {}
var current_state: State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.fsm = self
			child.state_ready()

	current_state = get_node(initial_state) as State
	current_state.enter()

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event):
	if current_state:
		current_state.handle_input(event)

func change_state(new_state_name: String):
	if not states.has(new_state_name):
		push_error("State '%s' not found!" % new_state_name)
		return

	current_state.exit()
	current_state = states[new_state_name]
	current_state.enter()
