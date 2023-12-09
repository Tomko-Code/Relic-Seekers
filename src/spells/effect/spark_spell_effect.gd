class_name SparkSpellEffect
extends SpellEffect

func apply_on_projectile(projectile: BaseProjectile):
	projectile.launched.connect(lauch_side_projectiles.bind(projectile))

func get_description():
	return "None: Empty spell effect"

func lauch_side_projectiles(projectile: BaseProjectile):
	await projectile.ready
	for x in range(1, randi_range(2,5)):
		var new_projectile: BaseProjectile = ProjectilesHandler.spawn_projectile(projectile.type, projectile.is_friendly)
		new_projectile.effects = projectile.effects
		new_projectile.position = projectile.position
		new_projectile.initialize(projectile.get_projectile_data())
		new_projectile.launch(projectile.launch_direction.rotated(deg_to_rad(randi_range(-15,15))))
		new_projectile.re_apply_effects()
		projectile.get_parent().call_deferred("add_child", new_projectile)
