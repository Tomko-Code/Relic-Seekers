extends Node2D

func _ready() -> void:
	if !GameData.save_file.portal_room_open:
		$AnimatedSprite2D.play("close")
	else:
		$AnimatedSprite2D.play("open")

func _on_interactable_component_interacted() -> void:
	if GameData.save_file.portal_room_open:
		get_tree().call_group("sanctuary_door", "on_closed")
		$AnimatedSprite2D.play("close")
		$AudioStreamPlayer.play()
	else:
		get_tree().call_group("sanctuary_door", "on_opend")
		$AnimatedSprite2D.play("open")
		$AudioStreamPlayer.play()
