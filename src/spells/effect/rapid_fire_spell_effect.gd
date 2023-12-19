class_name RapidFireSpellEffect
extends DirectSpellEffect

@export var tier: int = 0
@export var attack_spped_multiplier = [1.5, 2, 2.5, 3]

func init(value: int):
	texture = load("res://assets/art/icons/spell_effects/rapid_fire.png")
	tier = clampi(value, 0,3)
	return self

func apply_on_spell(spell: Spell):
	spell.shoot_frequency /= attack_spped_multiplier[tier]

func get_description():
	return get_bbcode_texture() + color_text(" Rapid Fire x%.1f" % attack_spped_multiplier[tier])
