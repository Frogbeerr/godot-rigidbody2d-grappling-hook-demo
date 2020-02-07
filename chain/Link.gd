extends Node2D

export (PackedScene) var anchor_scene
var anchor


func shoot_at(target_pos : Vector2) -> void:
	# Orient towards target
	rotate(get_angle_to(target_pos))
	# Stretch to the target
	var distance = (target_pos - to_global(position)).length()
	set_length(distance)
	# place anchor at target position
	var new_anchor : StaticBody2D = anchor_scene.instance()
	$RayCast2D.force_raycast_update()
	var target_body : PhysicsBody2D = $RayCast2D.get_collider()
	new_anchor.position = target_body.to_local(target_pos)
	target_body.add_child(new_anchor)
	new_anchor.get_node("Joint").node_b = get_path()
	anchor = new_anchor


func link_to(node_path : NodePath):
	$PinJoint2D.set_node_b(node_path)


func _exit_tree() -> void:
	anchor.queue_free()
	$PinJoint2D.queue_free()


func set_length(l : float) -> void:
	var target = Vector2(l, 0)
	$Line2D.points[1] = target
	#$CollisionShape2D.shape.b = target
	$RayCast2D.cast_to = target + Vector2(10, 0)


