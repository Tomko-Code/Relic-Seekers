class_name SparkSpellEffect
extends DirectSpellEffect

func apply_on_projectile(projectile: BaseProjectile):
	projectile.launched.connect(lauch_side_projectiles.bind(projectile))

func get_description():
	return "Spark Effect: Fires 1-4 additional projectiles"

func lauch_side_projectiles(projectile: BaseProjectile):
	await projectile.ready
	for x in range(3):
		var new_projectile: BaseProjectile = ProjectilesHandler.spawn_projectile(projectile.type, projectile.is_friendly)
		new_projectile.effects = projectile.effects
		new_projectile.position = projectile.position
		new_projectile.initialize(projectile.get_projectile_data())
		new_projectile.launch(projectile.launch_direction.rotated(deg_to_rad(randi_range(-15,15))))
		projectile.get_parent().call_deferred("add_child", new_projectile)
