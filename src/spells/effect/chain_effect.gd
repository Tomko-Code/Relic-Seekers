class_name ChainEffect
extends ProjectileSpellEffect

var tier: int
var chain_count_arr = [2,3]

func init(value):
	tier = clampi(value, 0, 1)
	return self

func _init():
	effect_type = Constants.effect_types.POSITIVE
	#texture = load("res://assets/art/icons/spell_effects/homing.png")

func apply_on_projectile(projectile: BaseProjectile):
	projectile.is_piercing = true
	projectile.pierce_count = chain_count_arr[tier]
	projectile.get_node("Components").add_child.call_deferred(ProjectileChainEffectSystem.new())


func get_description():
	return get_bbcode_texture() + color_text(" Chain +%s times") % chain_count_arr[tier]
