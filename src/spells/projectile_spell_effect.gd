class_name ProjectileSpellEffect
extends SpellEffect

func matching_archetype(spell):
	return spell.archetype == Constants.spell_archetypes.PROJECTILE
