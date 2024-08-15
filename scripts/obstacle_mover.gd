extends StaticBody3D


@export var motion: Vector3
@export var duration: float = 1

var modified_time_passed: float = 0
var delaying := true

@onready var mesh_instance = $MeshInstance3D


func _ready() -> void:
	if GameHandler.score < 5000:
		return
	mesh_instance.position -= motion
	if mesh_instance.global_position.z - GameHandler.player.global_position.z < 300:
		delaying = false
	await get_tree().create_timer(7.25 / GameHandler.player.speed_coefficient - duration + 1).timeout
	delaying = false


func _process(delta: float) -> void:
	if delaying:
		return
	if modified_time_passed >= duration:
		return
	mesh_instance.position += motion * delta * GameHandler.player.speed_coefficient / duration
	modified_time_passed += delta * GameHandler.player.speed_coefficient
