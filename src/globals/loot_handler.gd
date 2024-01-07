extends Node

var probability_loot_tables = {
	# to be used in generating standard_loot
	# [loot_type, loot chance %, loot min-max]
	standard_mob_loot = [
		["gold", 50, [1,4]],
		["emerald", 5, [1,1]],
		["mana_orb", 5, [1,1]],
		["spell", 3, [1,1]],
		["artifact", 3, [1,1]],
	],
	standard_boss_loot = [
		["gold", 100, [3,10]],
		["emerald", 25, [1,2]],
		["mana_orb", 10, [1,2]],
		["spell", 100, [1,2]],
	],
	standard_chest_loot = [
		["gold", 100, [5,10]],
	],
	chest_room_loot = [
		["chest", 100, [1,1]],
		["chest", 50, [1,1]],
		["chest", 25, [1,1]],
		["chest", 15, [1,1]],
	]
}

var weighted_loot_tables = {
	shop_loot_spells = [
		["spell", 5],
		["artifact", 2],
	],
	shop_loot_misc = [
		["mana_orb", 2],
		["heart", 3]
	],
	altar_loot = [
		["gold", 80],
		["emerald", 5],
		#["heart", 10],
		#["mana_orb", 10],
		#["gold_chest", 5],
	]
}
	


func create_standard_loot(loot_table_name: String) -> Array:
	if probability_loot_tables.has(loot_table_name):
		return create_standard_loot_from_loot_table(probability_loot_tables[loot_table_name])
	else:
		return []

func create_standard_loot_from_loot_table(loot_table: Array):
	var loot_array = []
	for loot_item in loot_table:
		var new_loot = create_loot_from_standard_loot_entry(loot_item)
		loot_array.append_array(new_loot)
	return loot_array

func create_weighted_loot(loot_table_name: String, loot_count: int) -> Array:
	if weighted_loot_tables.has(loot_table_name):
		return create_weighted_loot_from_loot_table(weighted_loot_tables[loot_table_name], loot_count)
	else:
		return []

func create_weighted_loot_range(loot_table_name: String, loot_min: int, loot_max: int) -> Array:
	if weighted_loot_tables.has(loot_table_name):
		return create_weighted_loot_from_loot_table(weighted_loot_tables[loot_table_name], randi_range(loot_min, loot_max))
	else:
		return []

func create_weighted_loot_from_loot_table(loot_table: Array, loot_count: int):
	var loot_array = []
	for x in range(loot_count):
		var loot_type = GameManager.get_random_from_weighed_array(loot_table)
		var new_loot = create_loot(loot_type)
		loot_array.append(new_loot)
	return loot_array


func create_loot_from_standard_loot_entry(loot_item: Array) -> Array:
	var loot_array = []
	var loot_type = loot_item[0]
	var loot_chance = float(loot_item[1])
	var loot_min = loot_item[2][0]
	var loot_max = loot_item[2][1]
	var spawn:bool = randf() <= (loot_chance / 100)
	if spawn:
		var loot_count = randi_range(loot_min, loot_max)
		for x in range(loot_count):
			loot_array.append(create_loot(loot_type))
	return loot_array

func create_loot(loot_type: String):
	var loot = null
	match loot_type:
		"gold":
			loot = PickupsHandler.create_gold_pickup() as GoldPickup
		"emerald":
			loot = PickupsHandler.create_emerald_pickup() as EmeraldPickup
		"mana_orb":
			loot = PickupsHandler.create_mana_orb_pickup() as ManaOrbPickup
		"heart":
			loot = PickupsHandler.create_heart_pickup() as HeartPickup
		"spell":
			var spell = SpellsHandler.create_random_spell()
			loot = SpellsHandler.create_spell_pickup(spell) as SpellPickup
		"artifact":
			var artifact = PickupsHandler.create_random_artifact()
			loot = PickupsHandler.create_artifact_pickup(artifact) as ArtifactPickup
		"chest":
			loot = PickupsHandler.create_chest()
	return loot
