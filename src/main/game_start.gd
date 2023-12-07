extends Node2D

@export var STARTING_OPTION:Constants.STARTING_OPTIONS = Constants.STARTING_OPTIONS.NORMAL

var load_preset = [
	["res://src/entities/projectiles/friendly_projectile.tscn", "projectile/friendly_projectile"],
]

#This is a scene for starting real game
func  _ready():
	ResourceManager.load_preset(load_preset)
	GameManager.load_scene("Game", "res://src/main/game.tscn")
	GameManager.load_scene("Menu", "res://src/menus/menu.tscn")
	
	# And setting !
	GameManager.loaded_scenes["Menu"].set_up_menu()
	
	match STARTING_OPTION:
		Constants.STARTING_OPTIONS.NORMAL:
			normal_start()
		Constants.STARTING_OPTIONS.COMBAT:
			combat_start()
	
	queue_free()

func normal_start() -> void:
	GameManager.switch_active_scene_to("Menu")
	GameManager.GAME_STATE = GameManager.GAME_STATES.MENU

func combat_start() -> void:
	GameManager.switch_active_scene_to("Game")
	GameManager.GAME_STATE = GameManager.GAME_STATES.GAME
	GameManager.loaded_scenes["Game"].start_game(Constants.STARTING_OPTIONS.COMBAT)
