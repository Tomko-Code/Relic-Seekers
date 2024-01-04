extends Node2D
class_name StoneTeleportSanctuaryNewRun

@export var interactable_component:InteractibleComponent

func _ready():
	pass

func _on_interactable_component_interacted():
	var game:Game = GameManager.loaded_scenes["Game"]
	
	var level_preset:LevelGenerationPreset = ResourceLoader.load("res://assets/level_generation_presets/0_preset.tres")
	while true:
		# This might fail in some cases
		var level:Level = LevelGenerator.generate(level_preset)
		
		if level != null:
			game.change_current_level(level)
			game.change_active_to_current_level()
			return
	
