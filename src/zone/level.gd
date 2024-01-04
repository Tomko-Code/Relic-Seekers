extends Node2D
class_name Level

signal level_activated

var room_connection_res = preload("res://src/zone/room_connection.tscn")

var map = []
var unspawned_rooms = []
var rooms = []
var currnet_active_room:Room = null
var default_room:Room = null
var level_size:Vector2 = Vector2.ZERO

var player_spawn_pos:Vector2 = Vector2.ZERO

var custom_spawn:bool = false

func spawn_room(room_data:RoomData) -> Room:
	if room_data.type == "":
		print("Cant spawn room with no type")
		return
	
	if not GameData.rooms_data.has(room_data.type):
		print("Room type does not exist : " + room_data.type)
		return
	
	var room:Room = GameData.rooms_data[room_data.type]["res"].instantiate()
	room.data = room_data
	
	unspawned_rooms.erase(room_data)
	rooms.append(room)
	
	# Add gates
	for closed_connection in room_data.closed_connection_arry:
		var conn:RoomConnection = room_connection_res.instantiate()
		conn.data = closed_connection
		conn.position = Constants.CHUNK_SIZE * conn.data.inside_cord
		conn.position += Constants.CHUNK_SIZE/2
		
		conn.position += conn.data.direction * (Constants.CHUNK_SIZE/4)
		conn.position += conn.data.direction * Vector2(32*3, 0)
		room.add_child(conn)
		room.data.spawned_room = room
	
	room.position = Constants.CHUNK_SIZE * room.data.cord
	add_child(room)
	return room

# returns true or false wather if placed it will overlap space with already placed room
func is_overlaping(room_data:RoomData, cord:Vector2):
	for y in range(room_data.room_shape.size()):
		for x in range(room_data.room_shape[0].size()):
			var map_spot:bool = map[cord.y + y][cord.x + x] != null
			var room_spot:bool = room_data.room_shape[y][x] == 1
			if map_spot and room_spot:
				return true
	
	return false

func get_cord_center_position(cord:Vector2) -> Vector2:
	return (cord * Constants.CHUNK_SIZE) + Constants.CHUNK_SIZE/2

func place_room(room_data:RoomData, cord:Vector2):
	room_data.cord = cord
	for y in range(room_data.room_shape.size()):
		for x in range(room_data.room_shape[0].size()):
			if room_data.room_shape[y][x] == 1:
				map[cord.y + y][cord.x + x] = room_data
	
	unspawned_rooms.append(room_data)

func create_level(size: Vector2i):
	level_size = size
	map = create_2Darray(size, null)

func print_map():
	for row in map:
		print(row)

func print_number_map():
	
	for row in map:
		var string = ""
		for r in row:
			if r == null:
				string += str(0)+", "
			else:
				string += str(1)+", "
			
		print(string)

func at(room_cord:Vector2i) -> RoomData:
	return map[room_cord.y][room_cord.x]

# Acces [row][column]
func create_2Darray(size: Vector2i, filler: Variant = 0) -> Array:
	var array = []
	
	for y in range(size.y):
		array.append([])
		array[y].resize(size.x)
		array[y].fill(filler)
	
	return array

func cord_outside_map(cord:Vector2) -> bool:
	var out_left:bool = cord.x < 0
	var out_top:bool = cord.y < 0
	var out_right:bool = cord.x >= level_size.x
	var out_bottom:bool = cord.y >= level_size.y
	
	if (out_left or out_top or out_right or out_bottom):
		return true
	
	return false


func reveal_level():
	for room in rooms:
		room.visited = true
		room.seen = true
		room.known = true
		room.emit_signal("status_change")

#### Virtual
func set_up(args:Array = []) -> void:
	pass
