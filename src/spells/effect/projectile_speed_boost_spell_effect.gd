class_name ProjectileSpeedBoostSpellEffect
extends SpellEffect

var tier
var speed_multipliers = [1.25, 1.5, 1.75, 2]

func _init(_tier: int):
	tier = clampi(_tier, 0,3)
	

func apply_on_projectile(projectile: BaseProjectile):
	projectile.speed *= speed_multipliers[tier]

func get_description():
	return "Projecttile Speed Boost: Projectiles fly %s%s faster" % [speed_multipliers[tier] * 100, "%"]
