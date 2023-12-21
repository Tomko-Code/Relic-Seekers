class_name MaxManaEffect
extends DirectSpellEffect

@export var tier: int
@export var mana_multiplier = [0.7, 0.85, 1.25, 1.5]

func init(value: int):
	effect_type = Constants.effect_types.POSITIVE if value >= 2 else Constants.effect_types.NEGATIVE
	texture = load("res://assets/art/icons/spell_effects/speed_boost.png")
	tier = clampi(value, 0,3)
	return self

func apply_on_spell(spell: Spell):
	spell.max_mana *= mana_multiplier[tier]
	spell.mana = spell.max_mana

func get_description():
	return get_bbcode_texture() + color_text(" Max Mana x%s" % mana_multiplier[tier])
