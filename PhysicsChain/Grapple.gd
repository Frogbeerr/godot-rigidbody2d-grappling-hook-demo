extends State

signal Angle

export (Texture) var anchor_texture


var anchor : Sprite
var anchor_stack := []
var target_ray : RayCast2D


func update(delta : float) -> void:
	wrap()
	unwind()
	host.orbit(anchor.global_position)
	host.reel_in(anchor.global_position, delta)
	var points = [host.global_position, anchor.global_position]
	if anchor_stack:
		for a in anchor_stack:
			points.insert(2, a.global_position)
	$Rope.points = PoolVector2Array(points)
	


func input(event: InputEvent) -> void:
	if event.is_action_released("grapple"):
		change_state("Idle")


func state_enter() -> void:
	target_ray = host.get_node("TargetRay")
	anchor = Sprite.new()
	anchor.texture = anchor_texture
	var anchor_host : PhysicsBody2D = target_ray.get_collider()
	anchor_host.add_child(anchor)
	anchor.position = anchor_host.to_local(target_ray.get_collision_point())
	$Rope.visible = true


func create_anchor(anchor_host : PhysicsBody2D, anchor_pos : Vector2) -> Sprite:
	var new_anchor = Sprite.new()
	new_anchor.texture = anchor_texture
	anchor_host.add_child(new_anchor)
	new_anchor.position = anchor_host.to_local(anchor_pos)
	return new_anchor


func vect_angle(vect_a : Vector2, vect_b : Vector2) -> float:
	if vect_a.length() * vect_b.length() == 0:
		return 0.0
	return vect_a.dot(vect_b) / (vect_a.length() * vect_b.length())


func unwind() -> void:
	# Are there anchors to unwind to?
	if not anchor_stack:
		return
	# can I see the current anchor?
	target_ray.cast_to = host.to_local(anchor.global_position)
	target_ray.force_raycast_update()
	if target_ray.is_colliding() and (target_ray.get_collision_point() - anchor.global_position).length() > 3:
		return
	# can I see the previous anchor?
	target_ray.cast_to = host.to_local(anchor_stack[-1].global_position)
	target_ray.force_raycast_update()
	if target_ray.is_colliding() and (target_ray.get_collision_point() - anchor_stack[-1].global_position).length() > 3:
		return
	# are both anchors close together by angle?
	var can_unwind := true
	if not vect_angle(host.to_local(anchor.global_position), host.to_local(anchor_stack[-1].global_position)) > .95:
		can_unwind = false
	# or am I very close to 
	if can_unwind:
		anchor.queue_free()
		anchor = anchor_stack[-1]
		anchor_stack.remove(anchor_stack.size() - 1)


func wrap() -> void:
	target_ray.cast_to = host.to_local(anchor.global_position)
	target_ray.force_raycast_update()
	if target_ray.is_colliding():
		if (target_ray.get_collision_point() - anchor.global_position).length() < 3:
			return
		anchor_stack.append(anchor)
		anchor = create_anchor(target_ray.get_collider(), target_ray.get_collision_point())
	


func state_exit() -> void:
	anchor.queue_free()
	while anchor_stack:
		anchor_stack[0].queue_free()
		anchor_stack.remove(0)
	host.get_node("GravityField").gravity_vec = Vector2(0, 1)
	$Rope.visible = false
