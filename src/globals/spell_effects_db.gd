extends Node

var effects = {
	random = [
		[HomingEffect.new(),1],
		[ProjectileSpeedBoostSpellEffect.new().init(0),1],
		[ProjectileSpeedBoostSpellEffect.new().init(1),1],
		[ProjectileSpeedBoostSpellEffect.new().init(2),1],
		[ProjectileSpeedBoostSpellEffect.new().init(3),1],
		[RapidFireSpellEffect.new().init(0),1],
		[RapidFireSpellEffect.new().init(1),1],
		[RapidFireSpellEffect.new().init(2),1],
		[RapidFireSpellEffect.new().init(3),1],
		[BounceEffect.new(), 1],
		[PierceEffect.new().init(0),1],
		[PierceEffect.new().init(1),1],
		[PierceEffect.new().init(2),1],
		[ExtraProjectilesEffect.new().init(0), 1],
		[ExtraProjectilesEffect.new().init(1), 1],
		[ExtraProjectilesEffect.new().init(2), 1],
		[MaxManaEffect.new().init(0), 1],
		[MaxManaEffect.new().init(1), 1],
		[MaxManaEffect.new().init(2), 1],
		[MaxManaEffect.new().init(3), 1],
		[ManaCostEffect.new().init(0), 1],
		[ManaCostEffect.new().init(1), 1],
		[ManaCostEffect.new().init(2), 1],
		[ManaCostEffect.new().init(3), 1],
		[MasterOfFlames.new().init(1), 1],
		[MasterOfFlames.new().init(2), 1],
		[MasterOfFlames.new().init(3), 1],
		[ExplosiveEffect.new().init(0), 1],
		[ExplosiveEffect.new().init(1), 1],
		[ExplosiveEffect.new().init(2), 1],
		[ChainEffect.new().init(0), 1],
		[ChainEffect.new().init(1), 1],
	]
}

var conflicts_map = [
	[ChainEffect, PierceEffect],
	[ChainEffect, InstantMotionEffect]
]

func _init():
	var positive_effects = []
	var negative_effects = []
	for entry in effects.random:
		var effect = entry[0] as SpellEffect
		if effect.effect_type == Constants.effect_types.POSITIVE:
			positive_effects.append(entry)
		elif effect.effect_type == Constants.effect_types.NEGATIVE:
			negative_effects.append(entry)
	effects["negative"] = negative_effects
	effects["positive"] = positive_effects

func get_conflict_entries_for_effect(conflicts_arr: Array, effect: SpellEffect) -> Array:
	var ret_arr = []
	for entry in conflicts_arr:
		if is_instance_of(effect, entry[0]) or is_instance_of(effect, entry[1]):
			ret_arr.append(entry)
	return ret_arr

func effects_conflict(effect_a: SpellEffect, effect_b: SpellEffect) -> bool:
	var conflicts_arr = get_conflict_entries_for_effect(conflicts_map, effect_a)
	conflicts_arr = get_conflict_entries_for_effect(conflicts_arr, effect_b)
	if conflicts_arr.is_empty():
		return false
	else:
		return true

func effect_conflicts_array(effect: SpellEffect, effects: Array):
	var conflicts_arr = get_conflict_entries_for_effect(conflicts_map, effect)
	for sec_effect in effects:
		var sec_conflicts_arr = get_conflict_entries_for_effect(conflicts_arr, sec_effect)
		if not sec_conflicts_arr.is_empty():
			return true
	return false

func ensure_unique(effect: SpellEffect, pool: Array):
	var ret_arr = []
	for entry in pool:
		if entry[0].get_script() != effect.get_script():
			ret_arr.append(entry)
	return ret_arr

func random_effects_for_spell_from_pool(effects_pool, spell: Spell, effect_min: int, effect_max: int, no_repeats: bool):
	var random = randi_range(effect_min, effect_max)
	var pool = effects[effects_pool]
	var ret_effects = []
	while not pool.is_empty() and ret_effects.size() != random:
		var effect = GameManager.get_random_from_weighed_array(pool) as SpellEffect
		pool = ensure_unique(effect, pool)
		if effect.check_conditions(spell) and not ( no_repeats and spell.has_effect(effect) ):
			ret_effects.append(effect)
	return ret_effects

func random_effects_from_pool(effects_pool):
	var random = randi() % 4
	var pool = effects[effects_pool]
	var ret_effects = []
	while not pool.is_empty() and ret_effects.size() != random:
		var effect = GameManager.get_random_from_weighed_array(pool)
		pool = ensure_unique(effect, pool)
		ret_effects.append(effect)
	return ret_effects
