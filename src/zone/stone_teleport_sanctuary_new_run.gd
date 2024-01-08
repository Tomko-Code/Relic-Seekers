extends Node2D
class_name StoneTeleportSanctuaryNewRun

@export var interactable_component:InteractibleComponent

var scaling_levels:bool = true
var level_base:LevelGenerationPreset
func _ready():
	level_base = ResourceLoader.load("res://assets/level_generation_presets/0_preset.tres")

func _on_interactable_component_interacted():
	var game:Game = GameManager.loaded_scenes["Game"]

	var level_preset = level_base.duplicate()
	
	GameManager.level_depth += 1
	
	if scaling_levels:
		level_preset.difficulty = GameManager.level_depth
	
	level_preset.level_size = Vector2(100, 100)
	level_preset.start_position = Vector2(49,49)
	
	level_preset.random_start = false
	
	level_preset.min_rooms = 10 + (level_preset.difficulty * 5)
	level_preset.max_rooms = 10 + (level_preset.difficulty * 5)
	
	var special_rooms_count = GameManager.level_depth + randi_range(1, 3)
	var special_rooms = [
		"shrine_room",
		"chest_room"
	]
	for room in range(special_rooms_count):
		var random_special = special_rooms.pick_random()
		if not level_preset.special_rooms.has(random_special):
			level_preset.special_rooms[random_special] = {}
			level_preset.special_rooms[random_special]["count"] = 0
		
		level_preset.special_rooms[random_special]["count"] += 1
	
#	special_rooms
#	"shop": {
#"count": 1.0
#}
	while true:
		# This might fail in some cases
		var level:Level = LevelGenerator.generate(level_preset)
		
		if level != null:
			game.change_current_level(level)
			game.change_active_to_current_level()
			return
	
