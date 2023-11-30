extends Node

@onready var Console = load("res://src/console/console.tscn").instantiate()
var all_commands = {}

func _ready():
	var a = TextEdit.new()
	a.text_set
	add_child(Console)
	Console.hide()
	
	register_command("help", cmd_help)

func _input(event):
	if event.is_action_pressed("open_console"):
		Console.visible = !Console.visible
		await get_tree().process_frame
		if Console.visible:
			Console.get_node("Console/TextEdit").grab_focus()
			Console.get_node("Console/TextEdit").clear()

func register_command(command_name: String, callback: Callable):
	all_commands[command_name] = callback

func process_command(full_command: String):
	var command = full_command.split(" ")[0]
	if command in all_commands:
		all_commands[command].call(full_command)
	else:
		print("missing command")
			
func cmd_help(args: String):
	for a_command in all_commands:
		print("%s: %s" % [a_command, all_commands[a_command].get_method()])
