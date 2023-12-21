class_name MasterOfFlames
extends ProjectileSpellEffect

@export var tier: int = 0
@export var burn_chance_modifiers_array = [2,3,4]
@export var projectile_damage_modifiers_array = [0.75,0.7,0.6]
@export var burn_damage_modifiers_array = [1.25,1.75,2]


func _init():
	effect_type = Constants.effect_types.POSITIVE
	texture = load("res://assets/art/icons/spell_effects/master_of_flames.png")

func init(value: int):
	tier = clampi(value, 0, 2)
	return self

func check_conditions(spell: Spell):
	return super.check_conditions(spell) and \
		spell.projectile_data.get("damage_type") == Constants.damage_types.FIRE

func apply_on_projectile(projectile: BaseProjectile):
	projectile.damage *= projectile_damage_modifiers_array[tier]
	projectile.effect_chance_modifiers[Constants.entity_effects.BURNING] = burn_chance_modifiers_array[tier]
	projectile.effect_damage_modifiers[Constants.entity_effects.BURNING] = burn_damage_modifiers_array[tier]

func get_description():
	return get_bbcode_texture() + color_text(" Master of Flames" + \
		"\n -burn chance x%s\n -damage x%s\n -burn damage x%s" % \
		[burn_chance_modifiers_array[tier], projectile_damage_modifiers_array[tier], burn_damage_modifiers_array[tier]])
