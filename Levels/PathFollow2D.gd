extends PathFollow2D


export (int) var speed = 50


func _physics_process(delta: float) -> void:
	offset+= speed * delta