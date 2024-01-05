extends Node

var loot_tables = {
	# to be used in generating standard_loot
	# [loot_type, loot chance %, loot min-max]
	standard_mob_loot = [
		["gold", 50, [1,4]],
		["emerald", 6, [1,1]],
		["mana_orb", 5, [1,1]],
		["spell", 4, [1,1]],
		["artifact", 3, [1,1]],
	],
	standard_chest_loot = [
		["gold", 100, [5,10]],
	],
}

func create_standard_loot(loot_table_name) -> Array:
	if loot_tables.has(loot_table_name):
		return create_standard_loot_from_loot_table(loot_tables[loot_table_name])
	else:
		return []

func create_standard_loot_from_loot_table(loot_table: Array):
	var loot_array = []
	for loot_item in loot_table:
		var new_loot = create_loot_from_loot_item(loot_item)
		loot_array.append_array(new_loot)
	return loot_array

func create_loot_from_loot_item(loot_item: Array) -> Array:
	var loot_array = []
	var loot_type = loot_item[0]
	var loot_chance = float(loot_item[1])
	var loot_min = loot_item[2][0]
	var loot_max = loot_item[2][1]
	var spawn:bool = randf() <= (loot_chance / 100)
	if spawn:
		var loot_count = randi_range(loot_min, loot_max)
		for x in range(loot_count):
			match loot_type:
				"gold":
					var gold_pickup = PickupsHandler.create_gold_pickup() as GoldPickup
					loot_array.append(gold_pickup)
				"emerald":
					var emerald_pickup = PickupsHandler.create_emerald_pickup() as EmeraldPickup
					loot_array.append(emerald_pickup)
				"mana_orb":
					var mana_orb_pickup = PickupsHandler.create_mana_orb_pickup() as ManaOrbPickup
					loot_array.append(mana_orb_pickup)
				"heart":
					var heart_pickup = PickupsHandler.create_heart_pickup() as HeartPickup
					loot_array.append(heart_pickup)
				"spell":
					var spell = SpellsHandler.create_random_spell()
					var spell_pickup = SpellsHandler.create_spell_pickup(spell) as SpellPickup
					loot_array.append(spell_pickup)
				"artifact":
					var artifact = PickupsHandler.create_random_artifact()
					var artifact_pickup = PickupsHandler.create_artifact_pickup(artifact) as ArtifactPickup
					loot_array.append(artifact_pickup)
	return loot_array
