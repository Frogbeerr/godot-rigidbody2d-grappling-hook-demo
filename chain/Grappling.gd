extends State

func state_enter() -> void:
	host.launch()

func input(event : InputEvent) -> void:
	if event.is_action_released("grapple"):
		change_state("Idle")

func state_exit() -> void:
	host.clear_chain()