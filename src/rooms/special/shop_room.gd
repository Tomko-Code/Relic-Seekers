class_name ShopRoom
extends Room

@onready var shop_markers = get_tree().get_nodes_in_group("ShopMarker")


func _ready():
	$RestockInteractible.interacted.connect(restock_interaction)
	restock_shop()

func restock_interaction():
	if GameData.save_file.player_inventory.emeralds >= 1:
		GameData.save_file.player_inventory.emeralds -= 1
		restock_shop()

func restock_shop():
	var valid_markers = []
	for shop_marker in shop_markers:
		if shop_marker.get_parent() == self:
			valid_markers.append(shop_marker)
	var stock = []
	
	var spell_stock = LootHandler.create_weighted_loot("shop_loot_spells", 3)
	var misc_stock = LootHandler.create_weighted_loot("shop_loot_misc", 2)
	
	stock.append_array(spell_stock)
	stock.append_array(misc_stock)
	
	for index in range(5):
		var shop_marker = valid_markers[index] as ShopMarker
		var shop_item = stock[index]
		var purchasable = PickupsHandler.make_purchasable(shop_item)
		shop_marker.set_purchasable(purchasable)

