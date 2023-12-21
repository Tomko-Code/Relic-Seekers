class_name DirectProjectileSpellEffect
extends DirectSpellEffect

func apply_on_spell(spell: Spell):
	pass

func matching_archetype(spell):
	return spell.archetype == Constants.spell_archetypes.PROJECTILE

func use(spell: Spell):
	pass
