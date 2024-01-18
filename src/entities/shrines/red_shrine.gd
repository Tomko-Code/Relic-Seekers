class_name RedShrine
extends Shrine


func can_apply_on_spell(spell: Spell) -> bool:
	return not spell.get_meta("modified", false)

func apply_on_spell(spell: Spell):
	spell.set_meta("modified", true)
	var positive = SpellEffectsDb.random_effects_for_spell_from_pool("positive", spell, 1, 2, true) as Array
	var negative = SpellEffectsDb.random_effects_for_spell_from_pool("negative", spell, 0, 2, true)
	
	var pre_c_effects = positive.duplicate() as Array
	pre_c_effects.append_array(negative)
	
	var effects = []
	for peff in pre_c_effects:
		var add_effect_f = true
		for ceff in effects:
			if peff.get_script() == ceff.get_script():
				add_effect_f = false
				break
		if add_effect_f:
			effects.append(peff)
	
	for effect in effects:
		effect = effect as SpellEffect
		spell.add_effect(effect)

func get_description():
	return "Enhances a spell with 1-2 random\npositive effects and 0-2 random negative effects"

func get_title():
	return "Red Shrine"
