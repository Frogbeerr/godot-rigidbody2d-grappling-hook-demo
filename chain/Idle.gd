extends State

func update(delta : float):
	host.aim()


func input(event: InputEvent) -> void:
	if event.is_action_pressed("grapple") and host.get_node("TargetRay").is_colliding():
		change_state("Grappling")