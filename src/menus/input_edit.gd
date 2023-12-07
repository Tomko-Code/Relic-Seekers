extends MarginContainer

@export var input_lable:Label
@export var action_button:Button

var action:String = ""
var listening_to_event:bool = false

func set_input_edit(action:String, action_button_name:String):
	self.action = action
	
	if Settings.input_settings.data.has(action):
		Settings.set_action(action, Settings.input_settings.data[action])
	
	action_button.text = action_button_name
	update_input_lable()

func update_input_lable() -> void:
	input_lable.text = InputMap.action_get_events(action)[0].as_text().trim_suffix(" (Physical)")

func _input(event) -> void:
	if listening_to_event:
		if ((event is InputEventKey) || (event is InputEventMouseButton)) and event.pressed:
			Settings.set_action(action, event)
			listening_to_event = false
			
			update_input_lable()

func _on_input_button_pressed() -> void:
	input_lable.text = "Listening to new input . . ."
	listening_to_event = true
