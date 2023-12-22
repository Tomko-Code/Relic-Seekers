class_name PierceEffect
extends ProjectileSpellEffect

@export var tier: int 
@export var pierce_counts = [1,2,3,5]

func _init():
	effect_type = Constants.effect_types.POSITIVE
	texture = load("res://assets/art/icons/spell_effects/piercing.png")

func init(value):
	tier = clampi(value, 0, 3)
	return self

func apply_on_projectile(projectile: BaseProjectile):
	projectile.is_piercing = true
	projectile.pierce_count = pierce_counts[tier]

func get_description():
	return get_bbcode_texture() + color_text(" Piercing +%s") % pierce_counts[tier]
