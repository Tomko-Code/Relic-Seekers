extends MarginContainer

@export var value_master:Label
@export var value_music:Label
@export var value_ui:Label
@export var value_sfx:Label
@export var value_dialog:Label

func _on_master_value_changed(value):
	value_master.text = str(100+value) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), (((-value)/100)*-80) )

func _on_music_value_changed(value):
	value_music.text = str(100+value) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), (((-value)/100)*-80) )

func _on_ui_value_changed(value):
	value_ui.text = str(100+value) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), (((-value)/100)*-80) )

func _on_sfx_value_changed(value):
	value_sfx.text = str(100+value) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), (((-value)/100)*-80) )

func _on_dialog_value_changed(value):
	value_dialog.text = str(100+value) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialog"), (((-value)/100)*-80) )
