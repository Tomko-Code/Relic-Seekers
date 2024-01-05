extends Control
class_name PCGTool

var set_option_res = preload("res://src/pcg/set_option.tscn")
var room_selected_res = preload("res://src/pcg/selected_room.tscn")
var room_special_option_res = preload("res://src/pcg/special_room_option.tscn")
# Menu
@export var file_menu:MenuButton

# Settings
@export var level_name_edit:LineEdit
@export var generate_button:Button
@export var print_value_map_button:Button

@export var size_x_edit:LineEdit
@export var size_y_edit:LineEdit

@export var min_room_edit:LineEdit
@export var max_room_edit:LineEdit

@export var start_x_edit:LineEdit
@export var start_y_edit:LineEdit
@export var start_random:CheckBox

@export var all_set_list:VBoxContainer
@export var selected_room_list:VBoxContainer

@export var rooms:Node2D

# Shape weights
@export var s1x1_weight:SpinBox
@export var s1x2_weight:SpinBox
@export var s2x1_weight:SpinBox
@export var s2x2_weight:SpinBox
@export var sl1_weight:SpinBox
@export var sl2_weight:SpinBox
@export var sl3_weight:SpinBox
@export var sl4_weight:SpinBox

# Special room otions
@export var special_rooms:Control

# Level
var is_level_preset_loaded:bool = false: 
	set(value):
		is_level_preset_loaded = value
		
		generate_button.disabled = !value
		print_value_map_button.disabled = !value
		
		level_name_edit.editable = value
		
		# level size
		size_x_edit.editable = value
		size_y_edit.editable = value
		
		# Rooms
		min_room_edit.editable = value
		max_room_edit.editable = value
		
		# Start
		start_x_edit.editable = value
		start_y_edit.editable = value
		start_random.disabled = !value
		
		s1x1_weight.editable = value
		s1x2_weight.editable = value
		s2x1_weight.editable = value
		s2x2_weight.editable = value
		sl1_weight.editable = value
		sl2_weight.editable = value
		sl3_weight.editable = value
		sl4_weight.editable = value

var level:Level = null
var level_preset:LevelGenerationPreset = null : set = set_level_preset

var level_preset_name:String = ""
var file_path:String = "res://assets/level_generation_presets/"

func _ready() -> void:
	file_menu.get_popup().id_pressed.connect(handle_file_menu)
	
	for set in GameData.room_sets:
		print(set)
		var set_option:SelectOption = set_option_res.instantiate()
		set_option.name = set
		set_option.set_name.text = set
		
		set_option.selected.connect(on_set_selected)
		
		all_set_list.add_child(set_option)
		
		for room in GameData.special_rooms:
			var option:SpecialRoomOption = room_special_option_res.instantiate()
			option.set_type(room)
			special_rooms.add_child(option)

func on_set_selected(value:String, pressed:bool):
	
	
	return
	#var room_selected:SelectedRoom = room_selected_res.instantiate()
	#room_selected.slect_button.text = value
	#room_selected.toggle_panel.connect(deselect_selected_rooms)
	#room_selected.rooms = rooms
	#room_selected.set_up(value)
	#selected_room_list.add_child(room_selected)

func deselect_selected_rooms(value):
	
	if rooms.get_child_count() > 0:
		var room = rooms.get_child(0)
		rooms.remove_child(room)
	
	for x in selected_room_list.get_children():
		if x != value:
			x.settings.hide()

func set_level_preset(value:LevelGenerationPreset) -> void:
	level_preset = value
	
	if level_preset == null:
		return
	
	print("Preset change setting up : " + value.level_name)
	level_name_edit.text = level_preset.level_name
	
	size_x_edit.text = str(level_preset.level_size.x)
	size_y_edit.text = str(level_preset.level_size.y)
	
	start_x_edit.text = str(level_preset.start_position.x)
	start_y_edit.text = str(level_preset.start_position.y)
	
	min_room_edit.text = str(level_preset.min_rooms)
	min_room_edit.text = str(level_preset.max_rooms)
	
	s1x1_weight.value = level_preset.shape_weights["1x1"]
	s1x2_weight.value = level_preset.shape_weights["1x2"]
	s2x1_weight.value = level_preset.shape_weights["2x1"]
	s2x2_weight.value = level_preset.shape_weights["2x2"]
	sl1_weight.value = level_preset.shape_weights["l1"]
	sl2_weight.value = level_preset.shape_weights["l2"]
	sl3_weight.value = level_preset.shape_weights["l3"]
	sl4_weight.value = level_preset.shape_weights["l4"]
	
	# Sets
	for set_option in all_set_list.get_children():
		set_option.level_preset = level_preset
		
		if level_preset.room_sets.has(set_option.name):
			set_option.select_set.button_pressed = true
		else:
			set_option.select_set.button_pressed = false
	
	for option in special_rooms.get_children():
		option.set_level_gen_preset(level_preset)
	
	start_random.button_pressed = level_preset.random_start

func handle_file_menu(id:int) -> void:
	match id:
		0:
			file_new()
		1:
			file_load()
		2:
			file_save()

func file_load() -> void:
	clear_level_preset()
	$ConfirmationDialog.visible = true

func file_save() -> void:
	if is_level_preset_loaded == false:
		print("No preset is loaded")
		return
	
	var file_name:String = level_preset.level_name + "_preset.tres"
	var full_path:String = file_path + file_name
	
	print("Save preset : " + full_path)
	ResourceSaver.save(level_preset, full_path)

func file_new() -> void:
	if is_level_preset_loaded:
		clear_level_preset()
	
	print("Create new preset")
	level_preset = LevelGenerationPreset.new()
	is_level_preset_loaded = true

func clear_level_preset() -> void:
	clear_level()
	
	for c in selected_room_list.get_children():
		c.queue_free()
	
	print("Clear preset")
	level_preset = null


func clear_level() -> void:
	if level == null:
		return
	
	print("Clear level")
	level.queue_free()
	level = null

func _on_level_name_text_changed(new_text:String) -> void:
	level_preset.level_name = new_text

func _on_generate_pressed():
	clear_level()
	var time_start = Time.get_ticks_msec()
	var try_count = 1
	print("Generate level")
	level = LevelGenerator.generate(level_preset)
	while level == null:
		level = LevelGenerator.generate(level_preset)
		try_count += 1
	print(level.rooms.size())
	var time_now = Time.get_ticks_msec()
	var time_elapsed = (time_now - time_start)
	print("Time generated : " + str(time_elapsed/1000.0))
	print("Try count : " + str(try_count))
	$VBoxContainer/HBoxContainer/Level/Room/RoomView/LevelRender.render_level(level)
	level.reveal_level()

func _on_confirmation_dialog_confirmed():
	level_preset = ResourceLoader.load(file_path + level_preset_name)
	is_level_preset_loaded = true

func _on_line_edit_text_changed(new_text):
	level_preset_name = new_text

func _on_x_text_changed(new_text:String) -> void:
	if new_text == "":
		return
	
	if new_text.is_valid_int() == false:
		return
	
	level_preset.level_size.x = int(new_text)

func _on_y_text_changed(new_text:String) -> void:
	if new_text == "":
		return
	
	if new_text.is_valid_int() == false:
		return
	
	level_preset.level_size.y = int(new_text)

func _on_print_value_map_pressed():
	if level == null:
		return
	
	level.print_number_map()

func _on_start_x_text_changed(new_text):
	if new_text == "":
		return
	
	if new_text.is_valid_int() == false:
		return
	
	level_preset.start_position.x = int(new_text)

func _on_start_y_text_changed(new_text):
	if new_text == "":
		return
	
	if new_text.is_valid_int() == false:
		return
	
	level_preset.start_position.y = int(new_text)

func _on_random_start_toggled(button_pressed):
	level_preset.random_start = button_pressed

func _on_min_room_text_changed(new_text):
	if new_text == "":
		return
	
	if new_text.is_valid_int() == false:
		return
	
	level_preset.min_rooms = int(new_text)

func _on_max_room_text_changed(new_text):
	if new_text == "":
		return
	
	if new_text.is_valid_int() == false:
		return
	
	level_preset.max_rooms = int(new_text)

func _on_1x1_weight_value_changed(value):
	level_preset.shape_weights["1x1"] = int(value)

func _on_1x2_weight_value_changed(value):
	level_preset.shape_weights["1x2"] = int(value)

func _on_2x1_weight_value_changed(value):
	level_preset.shape_weights["2x1"] = int(value)

func _on_2x2_weight_value_changed(value):
	level_preset.shape_weights["2x2"] = int(value)

func _on_l1_weight_value_changed(value):
	level_preset.shape_weights["l1"] = int(value)

func _on_l2_weight_value_changed(value):
	level_preset.shape_weights["l2"] = int(value)

func _on_l3_weight_value_changed(value):
	level_preset.shape_weights["l3"] = int(value)

func _on_l4_weight_value_changed(value):
	level_preset.shape_weights["l4"] = int(value)
