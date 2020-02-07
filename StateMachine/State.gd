extends Node
class_name State

var host : Node
var controller

func _enter_tree() -> void:
	controller = get_parent()
	host = controller.host


func _ready() -> void:
	print_debug("State host: ", host)

func update(delta : float) -> void:
	pass

func state_enter() -> void:
	"""Will be called after the state is entered."""
	pass

func state_exit() -> void:
	"""Will be executed before the state is left."""
	pass

func change_state(name : String) -> void:
	controller.change_state(name)

func input(event : InputEvent) -> void:
	"""Input handler"""
	if event.is_action_type():
		print_debug("Input '", event, "' detected from state '", name, "'")