extends RefCounted
class_name RoomData

# distance by rooms from the start
var depth:int

# type
var type:String = ""

# cord on the map
var cord:Vector2 = Vector2.ZERO

# Example
# room_shape = [
#	[1, 1]
#	[1, 0]
#]
#
var room_shape:Array = []

# Connections
var connection_arry:Array = []
var closed_connection_arry:Array = []
var all_possible_connections:Array = []

# Teleports
var has_teleport:bool = false
var teleport:TeleportData = null

# physical shape
var spawned_room:Room = null

var has_waves:bool = false
var waves = []

var max_connections:int = -1
var connection_count:int = 0
var banned_connections:Array = []

func set_up(_type:String, level:Level) -> RoomData:
	type = _type
	room_shape = GameData.rooms_data[_type]["shape"]
	
	# Teleport
	if GameData.rooms_data[_type].has("has_teleport"):
		has_teleport = GameData.rooms_data[_type]["has_teleport"]
		teleport = TeleportData.new()
	
	if GameData.rooms_data[_type].has("teleport_type"):
		teleport.type = GameData.rooms_data[_type]["teleport_type"]
	
	if GameData.rooms_data[_type].has("waves"):
		waves = GameData.rooms_data[_type]["waves"]
		has_waves = true
	
	return self

func generate_all_possible_connections(level:Level) -> void:
	for y in range(room_shape[0].size()):
		for x in range(room_shape.size()):
			if room_shape[y][x] == 1:
				if !level.cord_outside_map(Vector2(x,y) + cord + Vector2.LEFT):
					add_possible_connection(Vector2(x,y), Vector2.LEFT)
				
				if !level.cord_outside_map(Vector2(x,y)  + cord + Vector2.RIGHT):
					add_possible_connection(Vector2(x,y), Vector2.RIGHT)
				
				if !level.cord_outside_map(Vector2(x,y)  + cord + Vector2.UP):
					add_possible_connection(Vector2(x,y), Vector2.UP)
				
				if !level.cord_outside_map(Vector2(x,y)  + cord + Vector2.DOWN):
					add_possible_connection(Vector2(x,y), Vector2.DOWN)
	
	# LEGACY CODE FOR HAND MADE CONNECTIONS
	for conn in GameData.rooms_data[type]["connections"]:
		add_connection(conn[0], conn[1])

func add_possible_connection(inside_cord:Vector2, direction:Vector2):
	var new_connection:RoomConnectionData = RoomConnectionData.new()
	new_connection.inside_cord = inside_cord
	new_connection.direction = direction
	new_connection.parent_room = self
	
	# TEST FOR OUTSIDE
	var outside_cord:Vector2 = new_connection.get_outside_cord()
	
	var out_left:bool = outside_cord.x < 0
	var out_top:bool = outside_cord.y < 0
	var out_right:bool = outside_cord.x >= get_room_size().x
	var out_bottom:bool = outside_cord.y >= get_room_size().y
	
	if !(out_left or out_top or out_right or out_bottom):
		if room_shape[outside_cord.y][outside_cord.x] == 1:
			print("Connection is pointing to indide")
			return
	
	all_possible_connections.append(new_connection)

func add_connection(inside_cord:Vector2, direction:Vector2) -> RoomConnectionData:
	for conn in all_possible_connections:
		if conn.direction == direction and conn.inside_cord == inside_cord:
			var tmp:RoomConnectionData = conn
			all_possible_connections.erase(tmp)
			connection_arry.append(tmp)
			connection_count += 1
			return tmp
	
	return null

func get_random_connection() -> RoomConnectionData:
	if all_possible_connections.is_empty():
		return null
	else:
		return all_possible_connections.pick_random()

func get_random_cord_inside() -> Vector2:
	while true:
		var rand_cord:Vector2
		rand_cord.x = randi_range(0, get_room_size().x - 1)
		rand_cord.y = randi_range(0, get_room_size().y - 1)
		
		if room_shape[rand_cord.y][rand_cord.y] == 1:
			return rand_cord
	
	return Vector2.INF

func get_cord_center(_cord:Vector2) -> Vector2:
	return (_cord * Constants.CHUNK_SIZE) + (Constants.CHUNK_SIZE/2)

func remove_connection():
	pass

func connect_room(room:RoomData, conn:RoomConnectionData):
	var opo_conn:RoomConnectionData = room.get_connection(conn.get_map_outside_cord(), -conn.direction)
	
	if opo_conn == null:
		return false
	
	opo_conn.connected_room = self
	conn.connected_room = room
	
	closed_connection_arry.append(conn)
	room.closed_connection_arry.append(opo_conn)
	
	connection_arry.erase(conn)
	room.connection_arry.erase(opo_conn)
	
	return true

func get_connections_with_direction(direction:Vector2) -> Array[RoomConnectionData]:
	var result:Array[RoomConnectionData] = []
	
	for conn in connection_arry:
		if conn.direction == direction:
			result.append(conn)
	
	return result

func get_connection(_cord:Vector2, direction:Vector2) -> RoomConnectionData:
	_cord -= cord
	
	for conn in connection_arry:
		if conn.inside_cord == _cord and conn.direction == direction:
			return conn
	
	return null

func get_room_size() -> Vector2:
	return Vector2(room_shape[0].size(), room_shape.size())
