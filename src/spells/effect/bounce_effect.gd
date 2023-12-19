class_name BounceEffect
extends ProjectileSpellEffect

func _init():
	texture = load("res://assets/art/icons/spell_effects/bouncing.png")

func apply_on_projectile(projectile: BaseProjectile):
	projectile.can_bounce = true

func get_description():
	return get_bbcode_texture() + color_text(" Bouncing")
