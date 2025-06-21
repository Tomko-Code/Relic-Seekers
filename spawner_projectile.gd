extends Node2D

var speed: float = 200
var destination: Vector2

func _process(delta: float) -> void:
	position = position.move_toward(destination, delta * speed)
	
	if position.distance_to(destination) < 10:
		_spawn()

func _spawn() -> void:
	var game: Game = GameManager.loaded_scenes["Game"]
	var cord:Vector2 = position/Constants.FLOOR_TILE_SIZE
	cord = cord.floor()
	match GameData.save_file.cores_placed:
		0:
			game.active_level.currnet_active_room.spawn_enemy("goblin", cord)
		1:
			game.active_level.currnet_active_room.spawn_enemy("purple_goblin", cord)
		2:
			game.active_level.currnet_active_room.spawn_enemy("purple_goblin", cord)
		3:
			game.active_level.currnet_active_room.spawn_enemy("purple_goblin", cord)
	
	AudioManager.play_sfx(AudioDB.soundID.sfx_spawner_projectile)
	set_process(false)
	queue_free()
