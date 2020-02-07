extends Node2D

export (PackedScene) var chain_link
export (int) var max_range = 500


func _ready() -> void:
	$TargetRay.cast_to = Vector2(max_range, 0)
	$States.change_state("Idle")


func _physics_process(delta: float) -> void:
	$States.update(delta)


func aim() -> void:
	rotate(get_angle_to(get_global_mouse_position()))
	$TargetSprite.position = to_local($TargetRay.get_collision_point())
	$TargetSprite.visible = $TargetRay.is_colliding()


func launch() -> void:
	"""
	Launches the chain at the given target position. The target position has to be in the global coordinate system
	"""
	$TargetRay.force_raycast_update()
	if not $TargetRay.is_colliding():
		return
	var target : Vector2 = $TargetRay.get_collision_point()
	var target_body : PhysicsBody2D = $TargetRay.get_collider()
	var new_link : RigidBody2D = chain_link.instance()
	new_link.link_to(get_parent().get_path())
	$Links.add_child(new_link)
	new_link.shoot_at(target)


func clear_chain() -> void:
	for link in $Links.get_children():
		link.queue_free()