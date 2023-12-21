class_name ManaCostEffect
extends DirectSpellEffect

@export var tier: int
@export var mana_multiplier = [1.5, 1.25, 0.75, 0.5]

func init(value: int):
	effect_type = Constants.effect_types.POSITIVE if value >= 2 else Constants.effect_types.NEGATIVE
	texture = load("res://assets/art/icons/spell_effects/mana_cost.png") if value >= 2 else load("res://assets/art/icons/spell_effects/mana_cost_bad.png")
	tier = clampi(value, 0,3)
	return self

func apply_on_spell(spell: Spell):
	spell.mana_cost *= mana_multiplier[tier]

func get_description():
	return get_bbcode_texture() + color_text(" Mana Cost x%s" % mana_multiplier[tier])
