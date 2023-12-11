class_name ProjectileSpeedBoostSpellEffect
extends SpellEffect

@export var tier: int
@export var speed_multipliers = [1.25, 1.5, 1.75, 2]

func init(value: int):
	tier = clampi(value, 0,3)
	return self

func apply_on_projectile(projectile: BaseProjectile):
	projectile.speed *= speed_multipliers[tier]

func get_description():
	return "Projecttile Speed Boost: Projectiles fly %s%s faster" % [speed_multipliers[tier] * 100, "%"]
