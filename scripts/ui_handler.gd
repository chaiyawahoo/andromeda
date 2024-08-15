extends Control


func _ready() -> void:
	%StartButton.pressed.connect(start_game)
	%QuitButton.pressed.connect(quit_game)
	%CameraButton.pressed.connect(toggle_camera_follow)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


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
	if $StartLayer.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func toggle_camera_follow() -> void:
	GameHandler.camera_follow = not GameHandler.camera_follow
	if GameHandler.camera_follow:
		GameHandler.player.camera.position.y = 1
	else:
		GameHandler.player.camera.position.y = 4
