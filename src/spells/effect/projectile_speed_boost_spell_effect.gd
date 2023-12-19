class_name ProjectileSpeedBoostSpellEffect
extends ProjectileSpellEffect

@export var tier: int
@export var speed_multipliers = [1.25, 1.5, 1.75, 2]

func init(value: int):
	texture = load("res://assets/art/icons/spell_effects/speed_boost.png")
	tier = clampi(value, 0,3)
	return self

func apply_on_projectile(projectile: BaseProjectile):
	projectile.speed *= speed_multipliers[tier]

func get_description():
	return get_bbcode_texture() + color_text(" Speed Boost %s%s" % [speed_multipliers[tier] * 100, "%"])
