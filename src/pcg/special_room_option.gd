extends HBoxContainer
class_name SpecialRoomOption

@export var room_typ:Label
@export var check_button:CheckBox
@export var count:SpinBox

var level_preset:LevelGenerationPreset = null

func set_type(type:String):
	room_typ.text = type

func set_level_gen_preset(_level_preset:LevelGenerationPreset):
	level_preset = _level_preset
	print(level_preset)
	if level_preset.special_rooms.has(room_typ.text):
		check_button.button_pressed = true
		count.value = level_preset.special_rooms[room_typ.text]["count"]
	else:
		count.value = 1
		check_button.button_pressed = false

func _on_check_button_toggled(button_pressed):
	if level_preset == null:
		return
	
	if button_pressed:
		level_preset.special_rooms[room_typ.text] = {}
		level_preset.special_rooms[room_typ.text]["count"] = count.value
	else:
		level_preset.special_rooms.erase(room_typ.text)


func _on_count_value_changed(value):
	if level_preset == null:
		return
	
	if level_preset.special_rooms.has(room_typ.text):
		level_preset.special_rooms[room_typ.text]["count"] = int(count.value)
