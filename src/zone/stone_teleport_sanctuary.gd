extends Node2D
class_name StoneTeleportSanctuary

@export var interactable_component:InteractibleComponent

func _ready():
	pass

func _on_interactable_component_interacted():
	var level:ShowLevel = ShowLevel.new()
	var game:Game = GameManager.loaded_scenes["Game"]
	level.set_up()
	game.change_current_level(level)
	game.change_active_to_current_level()
