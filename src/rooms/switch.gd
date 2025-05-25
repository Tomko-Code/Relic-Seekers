extends Node2D

func _on_interactable_component_interacted() -> void:
	if GameData.save_file.portal_room_open:
		get_tree().call_group("sanctuary_door", "on_closed")
	else:
		get_tree().call_group("sanctuary_door", "on_opend")
