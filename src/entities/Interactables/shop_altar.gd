class_name ShopAltar
extends StaticBody2D

@onready var _InteractibleComponent: InteractibleComponent = $Components/InteractableComponent

func _ready():
	_InteractibleComponent.interacted.connect(on_interact)

func on_interact():
	var spell = GameData.save_file.player_inventory.drop_spell()
	if spell != null:
		var loot_count_min = max(int(spell.get_gold_value()/4), 1)
		var loot_count_max = max(int(spell.get_gold_value()/3), 2)
		var loot_array = LootHandler.create_weighted_loot_range("altar_loot", loot_count_min, loot_count_max)
		for pickup in loot_array:
			var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
			pickup.position = position + (random_direction * 10)
			pickup.push(random_direction)
			get_parent().call_deferred("add_child", pickup)
