extends Zone

func on_zone_enter(zone_spawn:int = 0):
	match zone_spawn:
		0:
			GameManager.player.global_position = $Spawns/SpawnProlog.global_position
			GameManager.player.paused = true

func on_zone_exit():
	pass
