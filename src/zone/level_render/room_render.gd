extends Node2D
class_name RoomRender

var room_ration:Vector2 = Vector2(5, 4)
var room_size:Vector2 = room_ration * Vector2(20, 20)
var border_size:int = 2
var room_margine:Vector2 = Vector2(0, 20)

var tp_button_res = preload("res://src/zone/level_render/tp_button.tscn")

var room:Room = null
var color:Color = Color("3b3b69")

var tp_button:TextureButton = null

var player_in:bool = false

func _ready():
	pass

func set_up():
	room.player_enterd.connect(player_enter)
	room.player_exit.connect(player_exit)
	room.status_change.connect(status_change)
	
	#position = room.data.cord * room_size
	position = (room.position/16)
	
	status_change()
		
	if room.data.has_teleport:
		tp_button = tp_button_res.instantiate()
		
		if room.has_node("Teleport"):
			tp_button.position = room.get_node("Teleport").position/16
			tp_button.position -= Vector2(24, 24)
			tp_button.pressed.connect(on_tp)
		
		add_child(tp_button)
	
	for conn in room.data.closed_connection_arry:
		var sprite:Sprite2D = Sprite2D.new()
		sprite.texture = load("res://assets/art/UI/big_arrow.svg")
		sprite.scale = Vector2(0.5, 0.5)
		sprite.position = Constants.CHUNK_SIZE * conn.inside_cord
		sprite.position += Constants.CHUNK_SIZE/2
		
		sprite.position += conn.direction * (Constants.CHUNK_SIZE/4)
		sprite.position += conn.direction * Vector2(88*3, 168)
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
			color = Color(0.20794501900673, 0.44472229480743, 0.76496165990829)
		else:
			color = Color("3b3b69")
	else:
		color = Color(0.09803921729326, 0.09803921729326, 0.09803921729326)
	
	if tp_button != null:
		if !(room.known and room.seen and room.visited):
			tp_button.disabled = true
			tp_button.hide()
		else:
			tp_button.disabled = false
			tp_button.show()

func player_enter():
	player_in = true
	color = Color(0.20794501900673, 0.44472229480743, 0.76496165990829)
	queue_redraw()

func player_exit():
	player_in = false
	color = Color("3b3b69")
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