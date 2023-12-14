extends Node2D
class_name StoneTeleportSwamp

@export var interactable_component:InteractibleComponent
var first_interaction = true

func _ready():
	GameManager.dialog_box.dialog_ended.connect(on_dialog_ended)
	

func _on_interactable_component_interacted():
	if first_interaction:
		GameManager.dialog_box.play("first_stone_interaction")
	else:
		var level:PrologLevel = PrologLevel.new()
		var game:Game = GameManager.loaded_scenes["Game"]
		level.set_up()
		game.change_current_level(level)
		game.change_active_to_current_level()

func on_dialog_ended(value:String):
	if value == "first_stone_interaction":
		first_interaction = false
