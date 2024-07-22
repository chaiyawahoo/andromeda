extends CharacterBody3D


var speed := 20
var is_vertical := false

var angle_goal = 0


func _input(event: InputEvent) -> void:
	var just_pressed := event.is_pressed() and not event.is_echo()
	if event.is_action("rotate") and just_pressed:
		angle_goal = 0 if is_vertical else [PI/2, -PI/2].pick_random()
		is_vertical = not is_vertical


func _physics_process(_delta: float) -> void:
	velocity = transform.basis.z * speed
	print($Ship.rotation)
	$Ship.rotation = Vector3(PI/2, 0, lerpf($Ship.rotation.z, angle_goal, 0.1))
	print(angle_goal)
	move_and_slide()
