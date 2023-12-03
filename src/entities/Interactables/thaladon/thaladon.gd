extends Node2D

func _ready():
	pass

func _on_interactable_component_interacted():
	if GameData.data["dialog"].has("first_thaladon_meeting"):
		GameManager.dialog_box.play("remark_thaladon_meeting")
		GameManager.player.paused = true
	else:
		GameManager.dialog_box.play("first_thaladon_meeting")
