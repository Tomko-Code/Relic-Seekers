class_name PierceEffect
extends ProjectileSpellEffect

func _init():
	texture = load("res://assets/art/icons/spell_effects/piercing.png")

func apply_on_projectile(projectile: BaseProjectile):
	projectile.is_piercing = true

func get_description():
	return get_bbcode_texture() + color_text(" Piercing")
