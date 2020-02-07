extends Node
class_name StateMachine

onready var host : Node
var state : State

func _enter_tree() -> void:
	host = get_parent()
	print_debug("SM Host: ", host)

func _ready() -> void:
	pass

func change_state(name : String) -> void:
	if state and state.has_method("state_exit"):
		state.state_exit()
		print_debug("State left: ", state.name)
	state = get_node(name)
	print_debug("State entered: ", state.name)
	state.state_enter()

func _input(event: InputEvent) -> void:
	state.input(event)


func update(delta : float) -> void:
	state.update(delta)