extends State


var target_ray : RayCast2D


func update(delta : float) -> void:
	target_ray.set_cast_to(host.to_local(host.get_global_mouse_position()))
	target_ray.force_raycast_update()
	if target_ray.is_colliding():
		$TargetMarker.set_position(target_ray.get_collision_point())
	else:
		$TargetMarker.set_position(host.get_global_mouse_position())


func state_enter() -> void:
	$TargetMarker.set_visible(true)
	target_ray = host.get_node("TargetRay")


func state_exit() -> void:
	$TargetMarker.set_visible(false)


func input(event : InputEvent) -> void:
	if event.is_action_pressed("grapple"):
		if target_ray.is_colliding():
			change_state("Grapple")