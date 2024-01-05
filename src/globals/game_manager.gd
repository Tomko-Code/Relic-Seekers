extends Node

enum GAME_STATES {MENU, GAME, TRANSITION}
var GAME_STATE: GAME_STATES = GAME_STATES.MENU
var current_scene = null

var game_camera: FollowCamera = load("res://src/other/FollowCamera.tscn").instantiate()

# Stuff from game spageti
var player: PlayerEntity = null
var dialog_box:Dialog = null
var hud:HUD = null
var map:Map = null

var loaded_scenes = {}

func _init():
	pass

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

func attach_camera_to_node(target_node: Node, _use_zones: bool = true,
	_interpolate_distance_from_mouse: bool = true, _speed: float = 3,
	_near_zone: float = 300, _far_zone: float = 400, _inner_zone: float = 0, 
	_draw_debug: bool = false):
	await get_tree().process_frame
	if game_camera.get_parent():
		game_camera.get_parent().remove_child(game_camera)
	target_node.add_child(game_camera)
	game_camera.initialize(_use_zones, _interpolate_distance_from_mouse, _speed, _near_zone,
		_far_zone, _inner_zone, _draw_debug)

func change_camera_parent(target_node: Node) -> void:
	#await get_tree().process_frame
	if game_camera.get_parent():
		game_camera.get_parent().remove_child(game_camera)
	target_node.add_child(game_camera)

func get_entity_component(entity, class_type):
	var components = []
	if entity.has_node("Components"):
		for component in entity.get_node("Components").get_children():
			if is_instance_of(component, class_type):
				components.append(component)
	return components

func get_random_from_weighed_array(arr):
	var total = 0
	for entry in arr:
		total += entry[1]
	var selection = randi() % total
	for entry in arr:
		selection -= entry[1]
		if selection < 0:
			return entry[0]

var tooltip_layer: CanvasLayer = null
var tooltip_node: Tooltip = null

func attach_tooltip(node, text_callback: Callable, hover_both: bool = true):
	if tooltip_node != null:
		#root.move_child.call_deferred(tooltip_node, -1) # probably better in on_hover_show but whatever
		pass
	else:
		var root = get_node("/root")
		tooltip_layer = CanvasLayer.new()
		tooltip_node = load("res://src/hud/tooltip.tscn").instantiate() as Tooltip
		tooltip_layer.add_child(tooltip_node)
		tooltip_layer.layer = 5
		tooltip_node.name = "Tooltip"
		root.add_child.call_deferred(tooltip_layer)
	if node is CollisionObject2D or node is Control:
		var callback = tooltip_node.on_hover_show.bind(node, text_callback, hover_both)
		if not node.mouse_entered.is_connected(callback):
			node.mouse_entered.connect(callback)


func detach_tooltip(node):
	if tooltip_node == null:
		return
	if node is CollisionObject2D or node is Control and node.mouse_entered.is_connected(tooltip_node.on_hover_show):
		var flagged_connection = []
		for con in node.mouse_entered.get_connections():
			print(con.callable.get_object())
			if con.callable.get_object() == tooltip_node:
				flagged_connection.append(con.callable)
		for callback in flagged_connection:
			node.mouse_entered.disconnect(callback)
	
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
