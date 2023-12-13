extends MarginContainer

@export var value_master:Label
@export var value_music:Label
@export var value_ui:Label
@export var value_sfx:Label
@export var value_dialog:Label

@export var master_slider:HSlider
@export var music_slider:HSlider
@export var ui_slider:HSlider
@export var sfx_slider:HSlider
@export var dialog_slider:HSlider

func _ready():
	pass

func set_up() -> void:
	set_up_value("master_volume", value_master, master_slider)
	set_up_value("music_volume", value_music, music_slider)
	set_up_value("ui_volume", value_ui, ui_slider)
	set_up_value("sfx_volume", value_sfx, sfx_slider)
	set_up_value("dialog_volume", value_dialog, dialog_slider)

func set_up_value(setting:String, lable:Label, slider:HSlider) -> void:
	var value
	
	if Settings.current_settings.has(setting):
		value = Settings.current_settings[setting]
	else:
		value = Settings.default_settings[setting]
	
	slider.value = value
	slider.emit_signal("value_changed", value)
	lable.text = str(100+value) + "%"

func _on_master_value_changed(value) -> void:
	value_master.text = str(100+value) + "%"
	Settings.set_master_volume((((-value)/100)*-80))

func _on_music_value_changed(value) -> void:
	value_music.text = str(100+value) + "%"
	Settings.set_music_volume((((-value)/100)*-80))

func _on_ui_value_changed(value) -> void:
	value_ui.text = str(100+value) + "%"
	Settings.set_ui_volume((((-value)/100)*-80))

func _on_sfx_value_changed(value) -> void:
	value_sfx.text = str(100+value) + "%"
	Settings.set_sfx_volume((((-value)/100)*-80))

func _on_dialog_value_changed(value) -> void:
	value_dialog.text = str(100+value) + "%"
	Settings.set_dialog_volume((((-value)/100)*-80))
