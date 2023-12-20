extends CanvasLayer
class_name Map

@export var level_render:LevelRender = null
@export var sub_view:SubViewport = null
@export var mini_map:TextureRect = null
@export var sub_view_container:SubViewportContainer = null 

var map_open:bool = false

func _ready():
	GameManager.map = self
	sub_view.render_target_update_mode = SubViewport.UPDATE_ALWAYS

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
			sub_view_container.visible = false
			sub_view_container.custom_minimum_size = Vector2(190, 190)
			sub_view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
			mini_map.visible = true
			map_open = false
			
			
		else:
			sub_view_container.custom_minimum_size = Vector2(1152, 648)
			map_open = true
			sub_view_container.visible = true
			mini_map.visible = false
