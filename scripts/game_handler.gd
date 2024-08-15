extends Node


signal world_found


var score := 0.0
var score_mulitplier := 100
var is_playing := false
var world: Node3D
var player: Player
var camera_follow := true


func _ready() -> void:
	_find_world()


func _process(delta: float) -> void:
	if is_playing:
		score += delta * score_mulitplier * player.speed_coefficient
		UIHandler.set_score(score)


func game_over() -> void:
	is_playing = false
	UIHandler.toggle_start_layer()


func _find_world() -> void:
	if not has_node("/root/World/Player"):
		await get_tree().process_frame
		_find_world()
		return
	world = $/root/World
	player = $/root/World/Player
	ModuleSpawner.spawn_position = 50
	for i in range(5):
		ModuleSpawner.spawn_module()
	world_found.emit()
