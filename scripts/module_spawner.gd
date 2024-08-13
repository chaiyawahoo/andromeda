extends Node


var spawn_position := 50
var spawn_distance := 50

var modules : Array[PackedScene] = [
	preload("res://scenes/modules/middle_vertical_module.tscn"),
	preload("res://scenes/modules/middle_horizontal_module.tscn"),
	preload("res://scenes/modules/left_vertical_module.tscn"),
	preload("res://scenes/modules/right_vertical_module.tscn"),
	preload("res://scenes/modules/middle_horizontal_split_module.tscn"),
	preload("res://scenes/modules/high_horizontal_split_module.tscn"),
	preload("res://scenes/modules/low_horizontal_split_module.tscn")
]


func spawn_module() -> void:
	if not GameHandler.world:
		return
	spawn_position += spawn_distance
	var module: Node3D = modules.pick_random().instantiate()
	module.position.z = spawn_position
	GameHandler.world.add_child(module)


func queue_despawn(module: Node3D) -> void:
	await get_tree().create_timer(2).timeout
	if module:
		module.queue_free()
