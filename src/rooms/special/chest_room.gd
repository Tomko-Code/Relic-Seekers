class_name ChestRoom
extends Room

func _ready():
	enemies_clear.connect(spawn_chests)

func spawn_chests():
	var markers = $ChestMarkers.get_children()
	markers.shuffle()
	var chests = LootHandler.create_standard_loot("chest_room_loot")
	
	for index in range(chests.size()):
		var marker = markers[index] as Marker2D
		var chest = chests[index] as Chest
		chest.position = marker.position + marker.get_parent().position
		add_child.call_deferred(chest)
	
