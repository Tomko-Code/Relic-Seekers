extends Node

enum GAME_STATES {MENU, GAME, TRANSITION}
var GAME_STATE: GAME_STATES = GAME_STATES.MENU
var current_scene = null

var loaded_scenes = {}

func _init():
	pass

# load scene
func load_scene(name: String, res_path: String):
	if loaded_scenes.has(name):
		print("game_manger:load_scene | scene :" + name + " is loaded.")
		return
	
	var _res = load(res_path)
	loaded_scenes[name] = _res.instantiate()

func switch_active_scene_to(scene_name: String):
	if !loaded_scenes.has(scene_name):
		print("game_manger:switch_active_scene_to | scene :" + scene_name + " is not loaded.")
		return
	
	if loaded_scenes[scene_name] == current_scene:
		print("game_manger:switch_active_scene_to | scene :" + scene_name + " is an active scene.")
		return
	
	await get_tree().process_frame
	
	if current_scene != null:
		get_tree().get_root().remove_child(current_scene)
	
	var new_active_scene = loaded_scenes[scene_name]
	get_tree().get_root().add_child(new_active_scene)
	
	current_scene = new_active_scene

func free_scene(scene_name: String):
	var scene = loaded_scenes[scene_name]
	
	if scene == null:
		print("game_manger:free_scene | scene :" + scene_name + " does not exist !")
		return
	
	if scene == current_scene:
		print("game_manger:free_scene | scene :" + scene_name + "is in use !")
		return
	
	scene.queue_free()

# just for quick test proly should be inside Menu !
# states maby not needed here !
func _input(event):
	if event.is_action_pressed("switch_to_menu"):
		if GAME_STATE == GAME_STATES.MENU:
			pass
		else:
			GAME_STATE = GAME_STATES.MENU
			switch_active_scene_to("Menu")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
