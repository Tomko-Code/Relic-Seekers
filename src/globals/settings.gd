extends Node

var path_save = "user://save_game_settings"
var path_save_input = "user://save_game_settings_input_map.tres"

signal setting_changed(setting:String, value)

# Settings
var current_settings = {}
var default_settings = {
	# Audio
	"master_volume" : 0,
	"music_volume" : 0,
	"ui_volume" : 0,
	"sfx_volume" : 0,
	"dialog_volume" :0,
	# Graphic
	"window_mode" : DisplayServer.WINDOW_MODE_WINDOWED,
	"vsync" : true,
	"show_fps" : true
}

var input_settings:InputSettings

func _ready() -> void:
	if ResourceLoader.exists(path_save_input):
		input_settings = ResourceLoader.load(path_save_input)
	else:
		input_settings = InputSettings.new()
	
	load_settings()

func _exit_tree() -> void:
	ResourceSaver.save( input_settings, path_save_input)
	
	save_settings()

func get_setting(setting:String):
	if current_settings.has(setting):
		return current_settings[setting]
	else:
		return default_settings[setting]

func set_setting(setting:String, value) -> void:
	current_settings[setting] = value
	emit_signal("setting_changed", setting, value)

func load_settings() -> void:
	if FileAccess.file_exists(path_save):
		var file = FileAccess.open(path_save, FileAccess.READ)
		var file_content = file.get_as_text()
		current_settings = JSON.parse_string(file_content)
		file.close()

func set_show_fps(value) -> void:
	set_setting("show_fps", value)

func save_settings() -> void:
	var file := FileAccess.open(path_save, FileAccess.WRITE)
	var file_content = JSON.stringify(current_settings)
	file.store_string(file_content)
	file.close()

func set_action(action:String, value) -> void:
	input_settings.data[action] = value
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, value)

func set_vsync(value) -> void:
	current_settings["vsync"] = value
	
	if value:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func set_window_mode(value) -> void:
	current_settings["window_mode"] = value
	DisplayServer.window_set_mode(value)

func set_master_volume(value) -> void:
	current_settings["master_volume"] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func set_music_volume(value) -> void:
	current_settings["music_volume"] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func set_ui_volume(value) -> void:
	current_settings["ui_volume"] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), value)

func set_sfx_volume(value) -> void:
	current_settings["sfx_volume"] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

func set_dialog_volume(value) -> void:
	current_settings["dialog_volume"] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialog"), value)
