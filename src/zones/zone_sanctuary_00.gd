extends Zone

func on_zone_enter(zone_spawn:int = 0):
	GameData.data["prolg_complete"] = true
	match zone_spawn:
		0:
			GameManager.player.global_position = $Spawns/PrologSpawn.global_position

