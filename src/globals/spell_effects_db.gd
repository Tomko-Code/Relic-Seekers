extends Node

var effects = {
	random = [
		[HomingEffect.new(),8],
		[ProjectileSpeedBoostSpellEffect.new().init(0),25],
		[ProjectileSpeedBoostSpellEffect.new().init(1),20],
		[ProjectileSpeedBoostSpellEffect.new().init(2),15],
		[ProjectileSpeedBoostSpellEffect.new().init(3),5],
		[RapidFireSpellEffect.new().init(0),25],
		[RapidFireSpellEffect.new().init(1),20],
		[RapidFireSpellEffect.new().init(2),17],
		[RapidFireSpellEffect.new().init(3),15],
		[RapidFireSpellEffect.new().init(4),8],
		[BounceEffect.new(), 8],
		[PierceEffect.new().init(0),20],
		[PierceEffect.new().init(1),15],
		[PierceEffect.new().init(2),10],
		[ExtraProjectilesEffect.new().init(0), 20],
		[ExtraProjectilesEffect.new().init(1), 15],
		[ExtraProjectilesEffect.new().init(2), 10],
		[MaxManaEffect.new().init(0), 15],
		[MaxManaEffect.new().init(1), 15],
		[MaxManaEffect.new().init(2), 10],
		[MaxManaEffect.new().init(3), 10],
		[ManaCostEffect.new().init(0), 10],
		[ManaCostEffect.new().init(1), 10],
		[ManaCostEffect.new().init(2), 10],
		[ManaCostEffect.new().init(3), 10],
		[MasterOfFlames.new().init(1), 25],
		[MasterOfFlames.new().init(2), 20],
		[MasterOfFlames.new().init(3), 15],
		[MasterOfFlames.new().init(4), 5],
		[ExplosiveEffect.new().init(0), 15],
		[ExplosiveEffect.new().init(1), 15],
		[ExplosiveEffect.new().init(2), 10],
		[ChainEffect.new().init(0), 12],
		[ChainEffect.new().init(1), 8],
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

func effect_conflicts_array(_effect: SpellEffect, _effects: Array):
	var conflicts_arr = get_conflict_entries_for_effect(conflicts_map, _effect)
	for sec_effect in _effects:
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

func prune_conflicts(effects_pool: Array, effect: SpellEffect) -> Array:
	var new_pool = []
	var conflicts_effect = get_conflict_entries_for_effect(conflicts_map, effect)
	for entry in effects_pool:
		var entry_effect = entry[0]
		var conflicts_entry_effect = get_conflict_entries_for_effect(conflicts_effect, entry_effect)
		if not conflicts_entry_effect.is_empty():
			continue
		else:
			new_pool.append(entry)
	return new_pool

func random_effects_for_spell_from_pool(effects_pool, spell: Spell, effect_min: int, effect_max: int, no_repeats: bool):
	var random = randi_range(effect_min, effect_max)
	var pool = effects[effects_pool]
	var ret_effects = []
	while not pool.is_empty() and ret_effects.size() != random:
		var effect = GameManager.get_random_from_weighed_array(pool) as SpellEffect
		pool = ensure_unique(effect, pool)
		if effect.check_conditions(spell) and not ( no_repeats and spell.has_effect(effect) ):
			ret_effects.append(effect)
			pool = prune_conflicts(pool, effect)
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
