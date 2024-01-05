extends HBoxContainer
class_name SelectOption

signal selected(name, pressed)

var level_preset:LevelGenerationPreset = null

@export var set_name:Label
@export var select_set:CheckButton

func _on_select_set_toggled(button_pressed):
	if level_preset == null:
		return
	
	if button_pressed:
		if !level_preset.room_sets.has(set_name.text):
			level_preset.room_sets.append(set_name.text)
	else:
		level_preset.room_sets.erase(set_name.text)
	
	emit_signal("selected", set_name.text, button_pressed)
