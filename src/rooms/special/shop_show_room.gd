class_name ShopRoom
extends Room

@onready var spikes_a = get_tree().get_nodes_in_group("ShopMarker")

func _ready():
	$RestockInteractible.interacted.connect(restock_interaction)

func restock_interaction():
	if GameData.save_file.player_inventory.emeralds >= 1:
		GameData.save_file.player_inventory.emeralds - 1
		restock_shop()

func restock_shop():
	pass
