extends Node

@onready var Console = load("res://src/console/console.tscn").instantiate()
var all_commands = {}

func _ready():
	add_child(Console)
	Console.hide()
	
	register_command("help", cmd_help)

func _input(event):
	if event.is_action_pressed("open_console"):
		print("console")
		Console.visible = !Console.visible
		await get_tree().process_frame
		if Console.visible:
			if GameManager.player != null: GameManager.player.paused = true
			Console.get_node("Console/TextEdit").grab_focus()
			Console.get_node("Console/TextEdit").clear()
		else:
			if GameManager.player != null: GameManager.player.paused = false

func register_command(command_name: String, callback: Callable):
	all_commands[command_name] = callback

func process_command(full_command: String):
	var command = full_command.split(" ")[0]
	if command in all_commands:
		all_commands[command].call(full_command)
	else:
		print("missing command")

@warning_ignore("unused_parameter")
func cmd_help(args: String):
	for a_command in all_commands:
		print("%s: %s" % [a_command, all_commands[a_command].get_method()])
