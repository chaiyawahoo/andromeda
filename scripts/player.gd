class_name Player
extends CharacterBody3D


var speed: float = 30
var speed_coefficient: float = 1
var rotation_coefficient: float = 10
var move_coefficient: float = 7
var is_vertical := false

var is_dead := false

var angle_goal: float = 0
var position_goal := Vector3.ZERO
var mouse_diff := Vector2.ZERO
var mouse_start := Vector2.ZERO

var ship_colliders: Array[CollisionShape3D]
@onready var ship_model: CSGPolygon3D = $ShipModel
@onready var camera: Camera3D = $Camera3D
@onready var camera_start: Vector3 = $Camera3D.position


func _ready() -> void:
	mouse_diff = get_viewport().get_mouse_position()
	ship_colliders.append($ShipWings)
	ship_colliders.append($ShipNose)
	$Sniffer.area_entered.connect(_on_area_entered_sniffer)


func _input(event: InputEvent) -> void:
	if not GameHandler.is_playing:
		return
	var just_pressed := event.is_pressed() and not event.is_echo()
	if event.is_action("rotate") and just_pressed:
		if not is_vertical:
			angle_goal = PI / 2 if ship_model.rotation.z > 0 else -PI/2
		else:
			angle_goal = 0
		is_vertical = not is_vertical
	if event is InputEventMouseMotion:
		mouse_diff += event.relative


func _process(delta: float) -> void:
	if not GameHandler.is_playing:
		return
	
	speed_coefficient += delta / 60.0
	
	position_goal = $Camera3D2.project_position(mouse_diff, 10)
	var mouse_diff_goal = get_viewport().get_camera_3d().project_position(mouse_diff, 10)
	
	if is_vertical:
		position_goal.x = clampf(position_goal.x, -7, 7)
		position_goal.y = clampf(position_goal.y, 0, 6)
	else:
		position_goal.x = clampf(position_goal.x, -3, 3)
		position_goal.y = clampf(position_goal.y, -3, 6)
	
	ship_model.position.x = lerpf(ship_model.position.x, position_goal.x, delta * move_coefficient)
	ship_model.position.y = lerpf(ship_model.position.y, position_goal.y, delta * move_coefficient)
	
	camera.position.x = lerpf(camera.position.x, position_goal.x * 1.25 + camera_start.x, delta * move_coefficient)
	camera.position.y = lerpf(camera.position.y, position_goal.y * 1.25 + camera_start.y, delta * move_coefficient)


func _physics_process(delta: float) -> void:
	if not GameHandler.is_playing:
		return
	
	move_ship(delta)
	var x_angle: float = (ship_model.position.x - position_goal.x) * delta * 5
	var y_angle: float = (ship_model.position.y - position_goal.y) * delta * 5
	rotate_ship(delta, x_angle, y_angle)
	
	velocity = transform.basis.z * speed * speed_coefficient
	if not move_and_slide():
		return
	for i in range(get_slide_collision_count()):
		if get_slide_collision(i).get_collider().get_collision_layer() == 2:
			die()
			return


func move_ship(delta: float) -> void:
	for ship_part in ship_colliders:
		ship_part.position.x = ship_model.position.x
		ship_part.position.y = ship_model.position.y
		if not is_vertical:
			ship_part.position.y += 0.25
		else:
			ship_part.position.x += -0.25 if angle_goal > 0 else 0.25


func rotate_ship(delta: float, x_angle: float, y_angle: float) -> void:
	if is_vertical:
		ship_model.rotation.z = lerpf(ship_model.rotation.z, angle_goal + x_angle, delta * rotation_coefficient)
		ship_model.rotation.x = lerpf(ship_model.rotation.x, PI/2 - sign(angle_goal) * x_angle, delta * rotation_coefficient)
		ship_model.rotation.y = lerpf(ship_model.rotation.y, -sign(angle_goal) * y_angle, delta * rotation_coefficient)
	else:
		ship_model.rotation.y = lerpf(ship_model.rotation.y, -x_angle, delta * rotation_coefficient)
		ship_model.rotation.z = lerpf(ship_model.rotation.z, angle_goal + x_angle, delta * rotation_coefficient)
		ship_model.rotation.x = lerpf(ship_model.rotation.x, PI/2 + y_angle, delta * rotation_coefficient)
	for ship_part in ship_colliders:
		ship_part.rotation = ship_model.rotation


func die() -> void:
	ship_model.queue_free()
	is_dead = true
	GameHandler.is_playing = false
	GameHandler.score = 0
	UIHandler.toggle_start_layer()


func _on_area_entered_sniffer(area: Area3D) -> void:
	ModuleSpawner.spawn_module()
	ModuleSpawner.queue_despawn(area.get_parent())
