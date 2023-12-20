class_name ExtraProjectilesEffect
extends DirectSpellEffect

@export var tier: int
@export var extra_projectile_counts = [1,2,3]

func init(value: int):
	effect_type = Constants.effect_types.POSITIVE
	texture = load("res://assets/art/icons/spell_effects/extra_projectiles.png")
	tier = clampi(value, 0,2)
	return self

func get_description():
	return get_bbcode_texture() + color_text(" Extra Projectiles +%s" % extra_projectile_counts[tier])

func apply_on_projectile(projectile: BaseProjectile):
	projectile.launched.connect(lauch_side_projectiles.bind(projectile))

func lauch_side_projectiles(projectile: BaseProjectile):
	await projectile.ready
	for x in range(extra_projectile_counts[tier]):
		var new_projectile: BaseProjectile = ProjectilesHandler.spawn_projectile(projectile.type, projectile.is_friendly)
		new_projectile.effects = projectile.effects
		new_projectile.position = projectile.position
		new_projectile.initialize(projectile.get_projectile_data())
		new_projectile.launch(projectile.launch_direction.rotated(deg_to_rad(randi_range(-20,20))))
		projectile.get_parent().call_deferred("add_child", new_projectile)
