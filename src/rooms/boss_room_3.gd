class_name BossRoom3
extends Room

var spawned = false

func on_player_enter():
	if not spawned:
		var boss = EnemiesHandler.spawn_boss("tezcati")
		enemy_count = 1
		boss.death.connect(on_enemy_death)
		#boss.modulate = Color.DARK_SLATE_BLUE;
		var spawn_point = spawn_point_res.instantiate() as SpawnerPoint
		boss.position = $SpawnSpot.position
		spawn_point.animation_player.speed_scale = 0.5
		spawn_point.position = $SpawnSpot.position
		spawn_point.enemy = boss
		spawn_point.room = self
		
		add_child.call_deferred(spawn_point)
		spawned = true
		
	super.on_player_enter()
