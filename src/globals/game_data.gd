extends Node

# presistent data saved here
var path_save := "user://save_game_presistent";

# Game INFO
# is it a first time player starts game
var is_new_game = true
var data = {}

func _ready():
	# load presistent data
	load_presistent()

func _exit_tree():
	# save presistent data
	save_presistent()

func load_presistent():
	if FileAccess.file_exists(path_save):
		var file = FileAccess.open(path_save, FileAccess.READ)
		var file_content = file.get_as_text()
		data = JSON.parse_string(file_content)
		file.close()

func save_presistent():
	var file := FileAccess.open(path_save, FileAccess.WRITE)
	var file_content = JSON.stringify(data)
	file.store_string(file_content)
	file.close()
