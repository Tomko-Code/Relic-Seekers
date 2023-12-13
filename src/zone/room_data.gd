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
var room_shape = []

# Connections
var connection_arry = []
var closed_connection_arry = []

func set_up(_type:String) -> RoomData:
	type = _type
	room_shape = GameData.rooms_data[_type]["shape"]
	for conn in GameData.rooms_data[_type]["connections"]:
		add_connection(conn[0], conn[1])
	
	return self

func add_connection(inside_cord:Vector2, direction:Vector2) -> void:
	var new_connection:RoomConnectionData = RoomConnectionData.new()
	new_connection.inside_cord = inside_cord
	new_connection.direction = direction
	new_connection.parent_room = self
	
	# TEST FOR DUPLICAT
	# TEST FOR OUTSIDE
	
	connection_arry.append(new_connection)

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
	
	print(closed_connection_arry)
	print(room.closed_connection_arry)
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
