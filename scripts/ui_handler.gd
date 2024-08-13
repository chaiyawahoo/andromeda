extends Control


func _ready() -> void:
	%StartButton.pressed.connect(start_game)
	%QuitButton.pressed.connect(quit_game)


func set_score(new_score: float) -> void:
	$ScoreLayer/Label.text = "Score: %d" % int(new_score)


func start_game() -> void:
	get_tree().reload_current_scene()
	GameHandler._find_world()
	await GameHandler.world_found
	GameHandler.is_playing = true
	toggle_start_layer()


func quit_game() -> void:
	get_tree().quit()


func toggle_start_layer() -> void:
	$StartLayer.visible = not $StartLayer.visible
