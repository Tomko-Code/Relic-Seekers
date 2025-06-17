extends Control

@export var main_menu:Control
@export var options:Control

func _enter_tree() -> void:
	AudioManager.play_music(AudioDB.soundID.music_menu, 1.0, 1.0)

func set_up_menu():
	options.set_up_options()

func _on_options_pressed():
	main_menu.hide()
	options.show()
