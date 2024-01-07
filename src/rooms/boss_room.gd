class_name BossRoom
extends Room

func on_player_enter():
	var boss = EnemiesHandler.spawn_boss("golem")
	enemy_count = 1
	boss.death.connect(on_enemy_death)
	
	var spawn_point = spawn_point_res.instantiate() as SpawnerPoint
	boss.position = $SpawnSpot.position
	var ap = spawn_point.animation_player as AnimationPlayer
	ap.speed_scale = 0.5
	spawn_point.position = $SpawnSpot.position
	spawn_point.enemy = boss
	spawn_point.room = self
	
	add_child.call_deferred(spawn_point)
	
	super.on_player_enter()
