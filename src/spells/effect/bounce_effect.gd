class_name BounceEffect
extends SpellEffect


func apply_on_projectile(projectile: BaseProjectile):
	projectile.can_bounce = true

func get_description():
	return "Bouncy: projectile bounces on contact with walls"
