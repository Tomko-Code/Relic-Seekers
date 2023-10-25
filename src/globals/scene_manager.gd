extends Node

#var scenes = {
#	test = {name="Test", scene=load("res://src/mockup/test.tscn")},
#	main_menu = {name="MainMenu", scene=load("res://src/scenes/main_menu/main_menu.tscn")},
#}

var current_scene : Node = null
var _current_root : Node

var sceneStack = []


func _init():
	#_load_scenes()


func setup(current_root):
	_current_root = current_root


func _ready():
	current_scene = get_tree().current_scene
	_current_root = current_scene


func _load_scenes():
	for sceneKey in scenes:
		if scenes[sceneKey].scene is String:
			scenes[sceneKey].scene = load(scenes[sceneKey].scene)


func _build_res(res):
	if res is GDScript:
		return res.new()
	elif res is PackedScene:
		return res.instantiate()

func change_scene(sceneKey):
	await get_tree().process_frame
	sceneStack = []
	current_scene.queue_free()
	current_scene = _build_res(scenes[sceneKey].scene)
	current_scene.name = scenes[sceneKey].name
	_current_root = current_scene
	get_tree().get_root().add_child(current_scene)


func get_top_scene():
	if !sceneStack.is_empty(): return sceneStack.back()
	else: return null


func closeTopNode():
	var node = sceneStack.pop_back()
	node.hide()
