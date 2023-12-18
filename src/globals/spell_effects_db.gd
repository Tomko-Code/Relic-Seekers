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
		[PierceEffect.new(), 1],
		[ExtraProjectilesEffect.new().init(0), 1],
		[ExtraProjectilesEffect.new().init(1), 1],
		[ExtraProjectilesEffect.new().init(2), 1],
	]
}


func ensure_unique(effect: SpellEffect, pool: Array):
	var to_delete = []
	for entry in pool:
		if entry[0].get_script() == effect.get_script():
			to_delete.append(entry)
	for entry in to_delete:
		pool.erase(entry)

func random_effects_from_pool(effects_pool):
	var random = randi() % 4
	var pool = effects[effects_pool].duplicate(true) as Array
	var ret_effects = []
	while not pool.is_empty() and ret_effects.size() != random:
		var effect = GameManager.get_random_from_weighed_array(pool)
		ensure_unique(effect, pool)
		ret_effects.append(effect)
	return ret_effects
