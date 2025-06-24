extends CanvasLayer
class_name Map

@export var level_render:LevelRender = null
@export var sub_view:SubViewport = null
@export var mini_map:Control = null
@export var sub_view_container:SubViewportContainer = null 


var map_open:bool = false

func _ready():
	GameManager.map = self
	sub_view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	level_render.camera.zoom = Vector2(0.5, 0.5)

func _on_game_level_change(level:Level):
	# Biiiiiiiig Spaggggettttti
	level_render.render_level(level)
	level.default_room.emit_signal("player_enterd")
	for conn in level.default_room.data.closed_connection_arry:
		var room_data:RoomData = conn.connected_room
		var room:Room = room_data.spawned_room
		room.known = true
		room.emit_signal("status_change")
	
	level.default_room.visited = true
	level.default_room.known = true
	level.default_room.seen = true
	level.default_room.emit_signal("status_change")

func _input(event):
	if Input.is_action_just_pressed("map"):
		if map_open:
			sub_view_container.custom_minimum_size = Vector2(100, 100)
			sub_view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
			
			sub_view_container.visible = false
			mini_map.visible = true
			map_open = false
			level_render.camera.zoom = Vector2(0.5, 0.5)
			print("minimap")
			level_render.camera.position = Vector2.ZERO
		else:
			sub_view_container.custom_minimum_size = Vector2(640, 360)
			
			map_open = true
			mini_map.visible = false
			sub_view_container.visible = true
			
			level_render.camera.zoom = Vector2(1, 1)
			print("map")

func _process(delta):
	if sub_view.render_target_update_mode != SubViewport.UPDATE_ALWAYS:
		sub_view.render_target_update_mode = SubViewport.UPDATE_ALWAYS

func _on_visibility_changed():
	pass

func _on_sub_viewport_container_visibility_changed():
	pass
