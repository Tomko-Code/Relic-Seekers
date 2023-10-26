extends Node2D

#This is a scene for starting real game
func  _ready():
	GameManager.load_scene("Game", "res://src/main/game.tscn")
	GameManager.load_scene("Menu", "res://src/menus/menu.tscn")
	
	GameManager.switch_active_scene_to("Menu")
	GameManager.GAME_STATE = GameManager.GAME_STATES.MENU
	
	queue_free()
