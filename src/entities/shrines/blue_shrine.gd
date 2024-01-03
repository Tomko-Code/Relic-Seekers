class_name BlueShrine
extends Shrine


func can_apply_on_spell(spell: Spell) -> bool:
	return not spell.get_meta("modified", false)

func apply_on_spell(spell: Spell):
	spell.set_meta("modified", true)
	var effects = SpellEffectsDb.random_effects_for_spell_from_pool("positive", spell, 1, 2, true)
	for effect in effects:
		effect = effect as SpellEffect
		spell.add_effect(effect)

func get_description():
	return "Enhances a spell with 1-2 random\npositive effects"

func get_title():
	return "Blue Shrine"
