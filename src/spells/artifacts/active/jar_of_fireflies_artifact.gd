class_name JarOfFireflies
extends ActiveArtifact


func _init():
	#frames = null
	max_charge = 0
	pass

func use():
	for x in range(5):
		var projectile = ProjectilesHandler.spawn_projectile("firefly", true)
		projectile.initialize(ProjectilesDb.projectiles["firefly"])
		GameManager.player.add_child(projectile)
		ProjectilesHandler.attach_orbital(GameManager.player, projectile, 40, 5)
	current_charge = 0
	emit_signal("used")

func get_title():
	return "Jar Of Fireflies"

func get_description():
	return "Spawns 5 fireflies orbiting the player"

