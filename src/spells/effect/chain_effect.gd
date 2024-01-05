class_name ChainEffect
extends ProjectileSpellEffect

func _init():
	effect_type = Constants.effect_types.NEUTRAL
	#texture = load("res://assets/art/icons/spell_effects/homing.png")

func apply_on_projectile(projectile: BaseProjectile):
	projectile.is_piercing = true
	projectile.pierce_count = 2
	projectile.get_node("Components").add_child.call_deferred(ProjectileChainEffectSystem.new())


func get_description():
	return get_bbcode_texture() + color_text(" Chain")
