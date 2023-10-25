extends Node

var scenes = {
	test = {name="Test", scene=load("res://src/scenes/root/Test.tscn")},
	main_menu = {name="MainMenu", scene=load("res://src/scenes/main_menu/MainMenu.tscn")},
}

var currentScene : Node = null
var _currentRoot : Node

var sceneStack = []


func _init():
	_load_scenes()


func setup(currentRoot):
	_currentRoot = currentRoot


func _ready():
	currentScene = get_tree().current_scene
	_currentRoot = currentScene


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
	currentScene.queue_free()
	currentScene = _build_res(scenes[sceneKey].scene)
	currentScene.name = scenes[sceneKey].name
	_currentRoot = currentScene
	get_tree().get_root().add_child(currentScene)


func get_top_scene():
	if !sceneStack.is_empty(): return sceneStack.back()
	else: return null


func closeTopNode():
	var node = sceneStack.pop_back()
	node.hide()
