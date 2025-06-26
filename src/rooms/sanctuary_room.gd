extends Room

@export var thaladon: Node2D
@export var path:PathFollow2D

var walking: bool = false


func _enter_tree() -> void:
	AudioManager.play_music(AudioDB.soundID.music_sanctuary, 1.0, 1.0)
	
	GameManager.game_camera.new_limit_left = 0
	GameManager.game_camera.new_limit_top = 0
	GameManager.game_camera.new_limit_right = 1000000
	GameManager.game_camera.new_limit_bottom = 1000000
	
	GameManager.game_camera.limit_left =  GameManager.game_camera.new_limit_left
	GameManager.game_camera.limit_right =  GameManager.game_camera.new_limit_right
	GameManager.game_camera.limit_bottom =  GameManager.game_camera.new_limit_bottom
	GameManager.game_camera.limit_top =  GameManager.game_camera.new_limit_top

func _ready():
	if GameData.save_file.cores_placed == 3:
		thaladon.position = $Marker2D.position
	
	GameData.save_file.last_core.connect(_on_last_placed)

func _process(_delta):
	if walking:
		thaladon.global_position = $Path2D/PathFollow2D/Marker2D.global_position

func _on_last_placed() -> void:
	if GameData.save_file.cores_placed == 3:
		var game: Game = GameManager.loaded_scenes["Game"]
		GameManager.hud.visible = false
		game.player.paused = true
		
		$Timer.start()

func _on_walk_done() -> void:
	walking = false
	GameManager.dialog_box.play("placed_last_core")
	GameManager.dialog_box.dialog_ended.connect(_on_dialog_ended)

func _on_dialog_ended(_name: String) -> void:
	var game: Game = GameManager.loaded_scenes["Game"]
	GameManager.dialog_box.dialog_ended.disconnect(_on_dialog_ended)
	game.player.paused = false


func _on_timer_timeout() -> void:
	thaladon.reparent(path)
	walking = true
	var tween:Tween = create_tween()

	tween.tween_property(path, "progress_ratio", 1, 2.5)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUART)
	tween.finished.connect(_on_walk_done)
