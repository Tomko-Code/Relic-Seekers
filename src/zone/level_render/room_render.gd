extends Node2D
class_name RoomRender

var room_ration:Vector2 = Vector2(5, 4)
var room_size:Vector2 = room_ration * Vector2(10, 10)
var border_size:int = 2
var room_margine:Vector2 = Vector2(0, 10)

var tp_button_res = preload("res://src/zone/level_render/tp_button.tscn")
var entrence_sprite_res = preload("res://assets/other/entrence_e_icon.tscn")
var room:Room = null
var color:Color = Color("3b3b69")

var unknow_color:Color = Color(0.09803921729326, 0.09803921729326, 0.09803921729326)

var tp_button:TextureButton = null

var player_in:bool = false

func _ready():
	pass

func set_up():
	room.player_enterd.connect(player_enter)
	room.player_exit.connect(player_exit)
	room.status_change.connect(status_change)
	
	color = room.data.base_color
	
	#position = room.data.cord * room_size
	position = (room.position/16)
	
	status_change()
	
	if GameData.rooms_data[room.data.type].has("icons"):
		for icon in GameData.rooms_data[room.data.type]["icons"]:
			var icon_dic:Dictionary = GameData.rooms_data[room.data.type]["icons"][icon]
			var new_icon = null
			match icon_dic["type"]:
				"texture":
					new_icon = Sprite2D.new()
					new_icon.scale.x = icon_dic["scale"]
					new_icon.scale.y = icon_dic["scale"]
					new_icon.texture = icon_dic["texture"]
					#print(str(icon["texture"]))
					new_icon.position += (Constants.CHUNK_SIZE/16)/2 * (icon_dic["cord"] + Vector2.ONE)
				"label":
					new_icon = icon_dic["res"].instantiate()
					if icon_dic.has("scale"):
						new_icon.scale.x = icon_dic["scale"]
						new_icon.scale.y = icon_dic["scale"]
					new_icon.position += (Constants.CHUNK_SIZE/16)/2
			add_child(new_icon)
	
	if room.data.is_start:
		var entrence_sprite = entrence_sprite_res.instantiate()
		entrence_sprite.position += (Constants.CHUNK_SIZE/16)/2
		
		add_child(entrence_sprite)
	
	if room.data.is_end:
		var end_sprite = entrence_sprite_res.instantiate()
		end_sprite.position += (Constants.CHUNK_SIZE/16)/2
		end_sprite.get_node("entrence_e_icon2").text = "X"
		
		add_child(end_sprite)
	
	if room.data.is_boss:
		var boss_sprite = Sprite2D.new()
		boss_sprite.texture = load("res://assets/art/UI/skull.png")
		boss_sprite.scale.x = 0.25/2
		boss_sprite.scale.y = 0.25/2
		boss_sprite.centered = true
		boss_sprite.position += (Constants.CHUNK_SIZE/16)
		
		add_child(boss_sprite)
	
	
	if room.data.has_teleport:
		tp_button = tp_button_res.instantiate()
		
		if room.has_node("Teleport"):
			tp_button.position = room.get_node("Teleport").position/16
			tp_button.position -= Vector2(24, 24)/2
			if not room.get_node("Teleport").visible:
				tp_button.set_simple_cirlce()
				#tp_button.modulate = Color(1.0, 1.0, 1.0, 0.0)
			
			tp_button.pressed.connect(on_tp)
			
		
		add_child(tp_button)
	
	elif room.data.add_teleport:
		tp_button = tp_button_res.instantiate()
		var center_offcet: Vector2 = Vector2(24,24)/2
		tp_button.position = ((room_size * room.data.get_random_cord_inside()) + (room_size/2)) - center_offcet
		tp_button.pressed.connect(on_tp)
		add_child(tp_button)
		
		var teleport: Node2D = Node2D.new()
		teleport.position = tp_button.position*16
		teleport.name = "Teleport"
		room.add_child(teleport)
	
	for conn in room.data.closed_connection_arry:
		var sprite:Sprite2D = Sprite2D.new()
		sprite.texture = load("res://assets/art/UI/big_arrow.svg")
		sprite.scale = Vector2(0.25, 0.25)
		sprite.position = Constants.CHUNK_SIZE * conn.inside_cord
		sprite.position += Constants.CHUNK_SIZE/2
		
		sprite.position += conn.direction * (Constants.CHUNK_SIZE/4)
		sprite.position += conn.direction * (Vector2(78*3, 170)/2)
		sprite.position /= 16
		
		sprite.rotate((-conn.direction).angle())
		
		sprite.z_index = 1
		add_child(sprite)

func on_tp() -> void:
	if room.room_closed:
		return
	
	GameManager.player.position = room.get_node("Teleport").global_position
	
	var active_level:Level = GameManager.loaded_scenes["Game"].active_level 
	active_level.currnet_active_room.emit_signal("player_exit")
	
	active_level.currnet_active_room = room
	active_level.currnet_active_room.on_player_enter()
	
	@warning_ignore("integer_division")
	@warning_ignore("narrowing_conversion")
	GameManager.game_camera.new_limit_left = room.global_position.x + (640/2)
	@warning_ignore("integer_division")
	@warning_ignore("narrowing_conversion")
	GameManager.game_camera.new_limit_top = room.global_position.y + (360/2)
	@warning_ignore("integer_division")
	@warning_ignore("narrowing_conversion")
	GameManager.game_camera.new_limit_right = room.global_position.x + (room.data.get_room_size().x * Constants.CHUNK_SIZE.x) - (640/2)
	@warning_ignore("integer_division")
	@warning_ignore("narrowing_conversion")
	GameManager.game_camera.new_limit_bottom = room.global_position.y + (room.data.get_room_size().y * Constants.CHUNK_SIZE.y) - (360/2)
	GameManager.game_camera.limit_left =  GameManager.game_camera.new_limit_left
	GameManager.game_camera.limit_right =  GameManager.game_camera.new_limit_right
	GameManager.game_camera.limit_bottom =  GameManager.game_camera.new_limit_bottom
	GameManager.game_camera.limit_top =  GameManager.game_camera.new_limit_top

func _draw():
	if room != null:
		draw_room()

func status_change():
	if room.known:
		show()
	else:
		hide()
	
	if room.seen:
		if player_in:
			color = room.data.highlight_color
		else:
			color = room.data.base_color
	else:
		color = unknow_color
	
	if tp_button != null:
		if !(room.known and room.seen and room.visited):
			tp_button.disabled = true
			tp_button.hide()
		else:
			tp_button.disabled = false
			tp_button.show()

func player_enter():
	player_in = true
	color = room.data.highlight_color
	queue_redraw()

func player_exit():
	player_in = false
	color = room.data.base_color
	queue_redraw()

func draw_room():
	var data:RoomData = room.data
	var room_shape_size:Vector2 = data.get_room_size()
	
	for y in room_shape_size.y:
		for x in room_shape_size.x:
			if data.room_shape[y][x] == 1:
				draw_rect(
					Rect2(
						(Vector2(x, y) * room_size),
						room_size + Vector2(border_size*2,border_size*2)
					),
					Color.WHITE,
					true,
				)
	
	for y in room_shape_size.y:
		for x in room_shape_size.x:
			if data.room_shape[y][x] == 1:
				draw_rect(
					Rect2(
						(Vector2(x, y) * room_size) + Vector2(border_size,border_size),
						room_size
					),
					color,
					true,
				)
