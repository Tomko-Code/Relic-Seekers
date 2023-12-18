class_name ShopRoom
extends Room

@onready var shop_markers = get_tree().get_nodes_in_group("ShopMarker")

var shop_stock = [
	["mana_orb", 1],
	["heart", 1],
	["artifact", 2],
	["spell", 2],
]

func _ready():
	$RestockInteractible.interacted.connect(restock_interaction)
	restock_shop()

func restock_interaction():
	if GameData.save_file.player_inventory.emeralds >= 1:
		GameData.save_file.player_inventory.emeralds - 1
		restock_shop()

func restock_shop():
	for shop_marker in shop_markers:
		shop_marker = shop_marker as ShopMarker
		var item_name = GameManager.get_random_from_weighed_array(shop_stock)
		match item_name:
			"mana_orb":
				var mana_orb_pickup = PickupsHandler.create_mana_orb_pickup()
				var purchasable = PickupsHandler.make_purchasable(mana_orb_pickup, 5)
				shop_marker.set_purchasable(purchasable)
			"heart":
				var heart_pickup = PickupsHandler.create_heart_pickup()
				var purchasable = PickupsHandler.make_purchasable(heart_pickup, 5)
				shop_marker.set_purchasable(purchasable)
			"spell":
				var spell = SpellsHandler.create_random_spell()
				var spell_pickup = SpellsHandler.create_spell_pickup(spell)
				var purchasable = PickupsHandler.make_purchasable(spell_pickup, 15)
				shop_marker.set_purchasable(purchasable)
			"artifact":
				var artifact = PickupsHandler.create_random_artifact()
				var artifact_pickup = PickupsHandler.create_artifact_pickup(artifact)
				var purchasable = PickupsHandler.make_purchasable(artifact_pickup, 15)
				shop_marker.set_purchasable(purchasable)
		
