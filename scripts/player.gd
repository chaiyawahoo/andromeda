extends CharacterBody3D


var speed := 20


func _physics_process(delta: float) -> void:
	velocity = transform.basis.z * speed
	move_and_slide()
