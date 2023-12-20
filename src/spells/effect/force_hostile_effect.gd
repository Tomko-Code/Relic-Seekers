class_name ForceHostileFffect
extends ProjectileSpellEffect


func apply_on_projectile(projectile: BaseProjectile):
	ProjectilesHandler.set_projectile_layer(projectile, false)

func get_description():
	return get_bbcode_texture() + color_text(" Target Player")
