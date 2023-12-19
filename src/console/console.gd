extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_edit_text_changed():
	var text_input = $Console/TextEdit
	if text_input.text.ends_with("\n"):
		ConsoleHandler.process_command(text_input.text.rstrip("\n"))
		text_input.clear()


func _on_button_pressed():
	GameManager.loaded_scenes["Game"].current_level.reveal_level()
	


func _on_button_2_pressed_death():
	GameManager.player.call_death()


func _on_button_3_pressed():
	GameData.save_file.player_inventory.gold += 50


func _on_button_4_pressed():
	GameData.save_file.player_inventory.emeralds += 50
