extends Control

@export var main_menu:Control
@export var options:Control

func set_up_menu():
	options.set_up_options()

func _on_options_pressed():
	main_menu.hide()
	options.show()
