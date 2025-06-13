extends Node2D
class_name StoneTeleportSanctuaryNewRun

@export var interactable_component:InteractibleComponent
var game:Game = null

var scaling_levels:bool = true
var level_base:LevelGenerationPreset
func _ready():
	level_base = ResourceLoader.load("res://assets/level_generation_presets/0_preset.tres")
	game = GameManager.loaded_scenes["Game"]

func _on_interactable_component_interacted():
	
	if GameManager.level_depth == Constants.FINAL_BOSS_LEVEL:
		GameData.just_killed_finall_boss = true
		game.reset_game()
		return
	
	var level_preset = level_base.duplicate() as LevelGenerationPreset
	
	GameManager.level_depth += 1
	level_preset.level_name = str(GameManager.level_depth)
	print("Next floor request ... level : " + str(level_preset.level_name) + " / 6")
	
	if scaling_levels:
		level_preset.difficulty = GameManager.level_depth
	
	set_boss_room(level_preset)
	print("Boss : " + level_preset.boss_room)
	
	level_preset.level_size = Vector2(1000, 1000)
	level_preset.start_position = Vector2(49,49)
	
	level_preset.random_start = false
	
	level_preset.min_rooms = 7 + (level_preset.difficulty * 4)
	level_preset.max_rooms = 7 + (level_preset.difficulty * 4)
	var special_rooms = [	
			"shrine_room",
			"chest_room"
	]
	
	if GameManager.level_depth == 1:
		level_preset.special_rooms["shrine_room"] = {}
		level_preset.special_rooms["chest_room"] = {}
		
		level_preset.special_rooms["shrine_room"]["count"] = 2
		level_preset.special_rooms["chest_room"]["count"] = 1
		level_preset.min_rooms = 5
		level_preset.max_rooms = 5
	else:
		var special_rooms_count = GameManager.level_depth + randi_range(1, 3)
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
	

func set_boss_room(level_preset:LevelGenerationPreset):
	#every other room 2, 4, 6 etc
	level_preset.is_boss_room_required = !(level_preset.difficulty%2)
	# if we don't need boss skip
	if !level_preset.is_boss_room_required:
		return
	
	match GameManager.level_depth:
		2:
			level_preset.boss_room = "test_boss_room"
		4:
			level_preset.boss_room = "boss_room_2"
		6:
			level_preset.boss_room = "boss_room_3"
