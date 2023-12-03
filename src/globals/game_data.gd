extends Node

# presistent data saved here
var path_save = "user://save_game_presistent"
var path_dialog_data = "res://assets/dialog_data.json"

# Game INFO
# is it a first time player starts game
var is_new_game = true
var dialog_data = {}
var data = {
	"prolg_complete": false,
}

func _ready():
	load_presistent()
	load_dialog_data()
	print(dialog_data)

# save presistent data on game exit
func _exit_tree():
	save_presistent()

func load_dialog_data():
	if FileAccess.file_exists(path_dialog_data):
		var file = FileAccess.open(path_dialog_data, FileAccess.READ)
		var file_content = file.get_as_text()
		dialog_data = JSON.parse_string(file_content)
		file.close()

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
