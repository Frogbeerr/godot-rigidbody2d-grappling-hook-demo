extends Node2D


signal Angle


export (int) var pull_strength = 500


var parent : RigidBody2D


func _ready() -> void:
	parent = get_parent()


func orbit(center : Vector2) -> void:
	var radius : Vector2 = to_global(position) - center
	# Restrict radial forces
	var angle : float
	if (parent.applied_force.length() * radius.length()) != 0:
		angle = acos(radius.dot(parent.applied_force) / (radius.length() * parent.applied_force.length()))
		var rad_force = cos(angle) * parent.applied_force.length()
		if rad_force > 0 or Input.is_action_pressed("stiffen_rope"):
			parent.add_central_force(radius.normalized() * -rad_force)
	
	# Restrict radial velocity
	if (parent.linear_velocity.length() * radius.length()) != 0:
		angle = acos(radius.dot(parent.linear_velocity) / (radius.length() * parent.linear_velocity.length()))
		var rad_vel = cos(angle) * parent.linear_velocity.length()
		if rad_vel > 0 or Input.is_action_pressed("stiffen_rope"):
			parent.apply_central_impulse(radius.normalized() * -rad_vel * parent.mass)
	
	# Restrict radial gravity
	angle = acos(radius.dot(Vector2(0, 1)) / radius.length())
	var grav_vec = Vector2(0, 1) - cos(angle) * radius.normalized()
	if angle > PI/2:
		grav_vec = Vector2(0, 1)
	$GravityField.gravity_vec = grav_vec


func reel_in(center : Vector2, delta : float) -> void:
	if Input.is_action_pressed("stiffen_rope"):
		return
	var radius : Vector2 = center - to_global(position)
	parent.apply_central_impulse(radius.normalized() * pull_strength * 10 * delta)


func _physics_process(delta: float) -> void:
	$StateMachine.update(delta)

func _on_Grapple_Angle(angle) -> void:
	emit_signal("Angle", angle)
