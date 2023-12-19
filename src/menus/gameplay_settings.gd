extends MarginContainer

@export var action_list:VBoxContainer
@export var check_box_fps:CheckBox

var input_button_res = preload("res://src/menus/input_edit.tscn")
var first_set_up:bool = true

var editable_actions = {
	"dash" : "Dash",
	"move_up" : "Move UP",
	"move_down" : "Move DOWN",
	"move_right" : "Move RIGHT",
	"move_left" : "Move LEFT",
	"map" : "Map/MiniMap",
	"artifact_slot_q" : "Use LEFT Artefact"
}

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_up():
	# fps
	check_box_fps.button_pressed = Settings.get_setting("show_fps")
	
	# Inputs
	for action in editable_actions:
		var input_button
		
		if first_set_up:
			input_button = input_button_res.instantiate()
			input_button.name = action
			action_list.add_child(input_button)
		else:
			input_button = action_list.get_node(action)
		
		input_button.set_input_edit(action, editable_actions[action])
	
	first_set_up = false


func _on_check_box_fps_toggled(button_pressed):
	Settings.set_setting("show_fps", button_pressed)
