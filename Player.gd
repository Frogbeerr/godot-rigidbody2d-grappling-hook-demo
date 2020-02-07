extends RigidBody2D



func _on_PhysicsChain_Angle(angle) -> void:
	$Label.text = "Angle: " + String(angle)