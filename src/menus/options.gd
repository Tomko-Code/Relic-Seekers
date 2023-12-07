extends CenterContainer

@export var audio:Control
@export var graphic:Control
@export var gameplay:Control

func set_up_options():
	audio.set_up()
	graphic.set_up()
	gameplay.set_up()

func reset_settings() -> void:
	Settings.current_settings = Settings.default_settings.duplicate()
	Settings.input_settings.data.clear()
	InputMap.load_from_project_settings()
	set_up_options()

func _on_reset_settings_pressed():
	reset_settings()
