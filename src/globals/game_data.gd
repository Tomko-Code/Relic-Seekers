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
	"Start" : {
		"shape" : [[1]],
		"res" : load("res://src/rooms/start_room.tscn"),
		"connections" : [
			[Vector2(0,0), Vector2.UP]
		]
	},
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
	"swamp_room" : {
		# This is wrong but it's unique room
		"shape" : [[1]],
		"res" : load("res://src/rooms/swamp_room.tscn"),
		"connections" : []
	}
}

func load_save_file():
	if ResourceLoader.exists(save_path):
		save_file = ResourceLoader.load(save_path)
	else:
		save_file = SaveFile.new()

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
