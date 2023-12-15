class_name PierceEffect
extends SpellEffect


func apply_on_projectile(projectile: BaseProjectile):
	projectile.is_piercing = true

func get_description():
	return "Piercing: projectile can hit multiple opponents"
