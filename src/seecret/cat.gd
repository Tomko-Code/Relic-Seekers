extends Node2D
class_name Cat

func _ready() -> void:
	if GameData.save_file.first_cat_interaction == false:
		idle()
	else:
		sleep()

func sleep():
	$CPUParticles2D.show()
	$AnimatedSprite2D.play("sleep")

func idle():
	$CPUParticles2D.hide()
	$AnimatedSprite2D.play("idle")

func _on_interactable_component_interacted() -> void:
	if not GameManager.dialog_box.dialog_ended.is_connected(_on_dialog_end):
		GameManager.dialog_box.dialog_ended.connect(_on_dialog_end)
	
	if GameData.save_file.first_cat_interaction == false:
		GameData.save_file.first_cat_interaction = true
		GameManager.dialog_box.play("cat_first_see")
		
	elif Utility.get_level_name() == "SanctuaryLevel":
		GameManager.dialog_box.play("cat_sanctuary")
		
	elif Utility.get_level_name() == "Floor":
		GameManager.dialog_box.play("cat_floor")
	
	idle()

func _on_dialog_end(_name: String) -> void:
	if GameManager.dialog_box.dialog_ended.is_connected(_on_dialog_end):
		GameManager.dialog_box.dialog_ended.disconnect(_on_dialog_end)
	$Timer.start()

func _on_timer_timeout() -> void:
	sleep()
