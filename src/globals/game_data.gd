extends Node

# presistent data saved here
var path_save_presistent = "user://save_game_presistent"
var path_dialog_data = "res://assets/dialog_data.json"
var save_path = "user://save.tres"

# Game INFO
# is it a first time player starts game
var is_new_game = true
var dialog_data = {}
var data = {
	"prolg_complete": false,
}

var save_file:SaveFile

# rooms data
var rooms_data = {
	#######################################
	# Test Rooms
	#######################################
	"Normal1" : {
		"shape" : [
			[1]
			#[1]
		],
		"res" : load("res://src/rooms/normal_room_0.tscn"),
		"connections" : [
			[Vector2(0,0), Vector2.DOWN]
		]
	},
	#######################################
	# Start Rooms
	#######################################
	"swamp_room" : {
		# This is wrong but it's unique room
		"shape" : [[1]],
		"res" : load("res://src/rooms/swamp_room.tscn"),
		"connections" : [],
		"has_teleport" : true,
		"teleport_type" : TeleportData.TELEPORT_TYPES.STONE
	},
	#######################################
	# Prolog Rooms
	#######################################
	"start_prolog_room" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/prolog/start_prolog_room.tscn"),
		"connections" : [[Vector2(0,0), Vector2.RIGHT]],
		"has_teleport" : true,
		"teleport_type" : TeleportData.TELEPORT_TYPES.CIRCLE
	},
	"kill_prolog_room" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/prolog/kill_prolog_room.tscn"),
		"connections" : [[Vector2(0,0), Vector2.UP],[Vector2(0,0), Vector2.RIGHT]],
		"waves" : [
			[[2, 2, ["goblin"]]]
		]
	},
	"end_prolog_room" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/prolog/end_prolog_room.tscn"),
		"connections" : [[Vector2(0,0), Vector2.UP]],
		"has_teleport" : true,
		"teleport_type" : TeleportData.TELEPORT_TYPES.STONE
	},
	"dash_prolog_room" : {
		"shape" : [[1, 1]],
		"res" : load("res://src/rooms/prolog/dash_prolog_room.tscn"),
		"connections" : [[Vector2(0,0), Vector2.LEFT],[Vector2(1,0), Vector2.RIGHT]],
	},
	"teleport_prolog_room" : {
		"shape" : [[1, 1]],
		"res" : load("res://src/rooms/prolog/teleport_prolog_room.tscn"),
		"connections" : [[Vector2(0,0), Vector2.LEFT],[Vector2(1,0), Vector2.DOWN]],
		"has_teleport" : true,
		"teleport_type" : TeleportData.TELEPORT_TYPES.CIRCLE
	},
	"trap_prolog_room" : {
		"shape" : [[1], [1]],
		"res" : load("res://src/rooms/prolog/trap_prolog_room.tscn"),
		"connections" : [[Vector2(0,0), Vector2.LEFT],[Vector2(0,1), Vector2.DOWN]],
	},
	#######################################
	# Sanctuary Rooms
	#######################################
	"sanctuary_room" : {
		# This is "broken" room
		"shape" : [[1]],
		"res" : load("res://src/rooms/sanctuary_room.tscn")
	},
	#######################################
	# Combat Rooms
	#######################################
	"main_combat_room" : {
		# This is "broken" room
		"shape" : [
			[1, 1, 1],
			[1, 1, 1],
			[1, 1, 1]
		],
		"res" : load("res://src/rooms/combat/main_combat_room.tscn"),
		"connections" : [
			[Vector2(0,1), Vector2.LEFT],
			[Vector2(2,1), Vector2.RIGHT],
			[Vector2(1,2), Vector2.DOWN],
			[Vector2(1,0), Vector2.UP],
		],
		"has_teleport" : true,
		"teleport_type" : TeleportData.TELEPORT_TYPES.CIRCLE
	},
	"left_combat_room" : {
		# This is "broken" room
		"shape" : [[1]],
		"res" : load("res://src/rooms/combat/left_combat_room.tscn"),
		"connections" : [[Vector2(0,0), Vector2.RIGHT]],
		"waves" : [
			[[100, 100, ["goblin"]]]
			#[[1, 1, ["test_mob_a"]]],
			#[[1, 1, ["test_mob_a"]],[1, 1, ["test_mob_a"]]]
		]
	},
	#######################################
	# Show
	#######################################
	"show_room" : {
		# This is "broken" room
		"shape" : [
			[1, 1],
			[1, 1]
		],
		"res" : load("res://src/rooms/special/show_room.tscn"),
		"connections" : [[Vector2(0,1), Vector2.LEFT]],
	},
	"shop_room" : {
		# This is "broken" room
		"shape" : [
			[1]
		],
		"res" : load("res://src/rooms/special/shop_room.tscn"),
		"connections" : [[Vector2(0,0), Vector2.RIGHT]],
	},
	#######################################
	# Show
	#######################################
	
	"1x1_small" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/pcg/standard/1x1_small.tscn")
	},
	"1x1_small_red" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/pcg/standard/1x1_small.tscn")
	},
	"1x1_small_coridor_up" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/pcg/standard/1x1_small.tscn")
	},
	#######################################
	# Important pcg rooms
	#######################################
	"end_room" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/pcg/standard/end_room.tscn")
	},
	"start_room" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/start_room.tscn")
	},
	"test_boss_room" : {
		"shape" : [[1, 1],[1, 1]],
		"res" : load("res://src/rooms/pcg/standard/2x2_standard.tscn")
	},
	#######################################
	# Standard pcg special rooms
	#######################################
	"shop" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/special/shop_room.tscn"),
		"icons" : {
			#"shop_icon" : {
			#	"type" : "texture",
			#	"texture" : preload("res://icon.svg"),
			#	"cord" : Vector2(0, 0),
			#	"scale" : 0.5
			#}
			"shop_icon" : {
				"type" : "label",
				"res" : preload("res://assets/other/shop_icon.tscn"),
			}
		},
	},
	"shrine_room" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/special/shrine_room.tscn"),
		"icons" : {
			"shrine_icon" : {
				"type" : "label",
				"res" : preload("res://assets/other/shrine_icon.tscn"),
			}
		},
	},
	"chest_room" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/special/chest_room.tscn"),
		"icons" : {
			"shrine_icon" : {
				"type" : "label",
				"res" : preload("res://assets/other/shrine_icon.tscn"),
			}
		},
		"waves" : [
			[[5, 10, ["goblin"]]]
			#[[1, 1, ["test_mob_a"]]],
			#[[1, 1, ["test_mob_a"]],[1, 1, ["test_mob_a"]]]
		]
	},
	#######################################
	# Standard pcg set
	#######################################
	"1x2_standard" : {
		"shape" : [[1],[1]],
		"res" : load("res://src/rooms/pcg/standard/1x2_standard.tscn")
	},
	"2x1_standard" : {
		"shape" : [[1, 1]],
		"res" : load("res://src/rooms/pcg/standard/2x1_standard.tscn")
	},
	"2x2_standard" : {
		"shape" : [[1, 1],[1, 1]],
		"res" : load("res://src/rooms/pcg/standard/2x2_standard.tscn")
	},
	"l1_standard" : {
		"shape" : [
			[1, 1],
			[1, 0]],
		"res" : load("res://src/rooms/pcg/standard/l1_standard.tscn")
	},
	"l2_standard" : {
		"shape" : [
			[1, 1],
			[0, 1]],
		"res" : load("res://src/rooms/pcg/standard/l2_standard.tscn")
	},
	"l3_standard" : {
		"shape" : [
			[0, 1],
			[1, 1]],
		"res" : load("res://src/rooms/pcg/standard/l3_standard.tscn")
	},
	"l4_standard" : {
		"shape" : [
			[1, 0],
			[1, 1]],
		"res" : load("res://src/rooms/pcg/standard/l4_standard.tscn")
	}
}

var room_sets:Dictionary = {
	"standard" : [
		"1x1_small",
		"1x2_standard",
		"2x1_standard",
		"2x2_standard",
		"l1_standard",
		"l2_standard",
		"l3_standard",
		"l4_standard",
	],
}

var special_rooms:Array = [
	"shop",
	"shrine_room",
	"chest_room"
]

func load_save_file():
	if ResourceLoader.exists(save_path):
		save_file = ResourceLoader.load(save_path)
	else:
		save_file = SaveFile.new()
	
	for spell_id in range(1, 5):
		var spell = save_file.player_inventory.spells[spell_id]
		if spell != null:
			SpellsHandler.add_spell(spell)

func write_save_file():
	ResourceSaver.save(save_file, save_path)

func _ready():
	data["dialog"] = {}
	load_presistent()
	load_dialog_data()
	load_save_file()

# save presistent data on game exit
func _exit_tree():
	write_save_file()
	save_presistent()

func load_dialog_data():
	if FileAccess.file_exists(path_dialog_data):
		var file = FileAccess.open(path_dialog_data, FileAccess.READ)
		var file_content = file.get_as_text()
		dialog_data = JSON.parse_string(file_content)
		file.close()

func load_presistent():
	if FileAccess.file_exists(path_save_presistent):
		var file = FileAccess.open(path_save_presistent, FileAccess.READ)
		var file_content = file.get_as_text()
		data = JSON.parse_string(file_content)
		file.close()

func save_presistent():
	var file := FileAccess.open(path_save_presistent, FileAccess.WRITE)
	var file_content = JSON.stringify(data)
	file.store_string(file_content)
	file.close()
