extends Node2D

func _ready():
	pass

func _on_interactable_component_interacted():
	if not GameManager.dialog_box.playing:
		if GameData.data["dialog"].has("first_thaladon_meeting"):
			if GameData.save_file.cores_placed == 3:
				GameManager.dialog_box.play("remark_thaladon_all_cores")
				
			else:
				GameManager.dialog_box.play("remark_thaladon_meeting")
				
		else:
			GameManager.dialog_box.play("first_thaladon_meeting")


func _on_interactable_component_focus_change(_focus):
	pass
