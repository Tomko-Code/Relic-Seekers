extends MarginContainer

@export var window_mode_options:OptionButton
@export var vsync:CheckBox

func set_up() -> void:
	set_up_window_mode_option_menu()
	set_up_flag("vsync", vsync)

func set_up_flag(setting:String, box:CheckBox) -> void:
	var value
	
	if Settings.current_settings.has(setting):
		value = Settings.current_settings[setting]
	else:
		value = Settings.default_settings[setting]
	
	vsync.button_pressed = value

func set_up_window_mode_option_menu() -> void:
	var value
	var index
	
	if Settings.current_settings.has("window_mode"):
		value = Settings.current_settings["window_mode"]
	else:
		value = Settings.default_settings["window_mode"]
	
	if DisplayServer.WINDOW_MODE_WINDOWED == value:
		index = 0
	elif DisplayServer.WINDOW_MODE_FULLSCREEN == value:
		index = 1
	
	window_mode_options.select(index)
	_on_window_mode_item_selected(index)

func _on_window_mode_item_selected(index) -> void:
	match window_mode_options.get_item_text(index):
		"WINDOW_MODE_WINDOWED":
			Settings.set_window_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		"WINDOW_MODE_FULLSCREEN":
			Settings.set_window_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_v_sync_mode_toggled(button_pressed):
	Settings.set_vsync(button_pressed)
