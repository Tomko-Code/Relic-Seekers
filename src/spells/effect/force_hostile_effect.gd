class_name ForceHostileFffect
extends ProjectileSpellEffect


func apply_on_projectile(projectile: BaseProjectile):
	ProjectilesHandler.set_projectile_layer(projectile, false)

func get_description():
	return "Target Player: projectile always hits the player"
