extends RefCounted
class_name RoomConnectionData

signal connection_closed
signal connection_opened

var connected_room:RoomData = null
var parent_room:RoomData = null

var closed:bool = false : set = set_closed

# cord inside room
var inside_cord:Vector2 = Vector2.ZERO

# where is connection to ?
var direction:Vector2 = Vector2.ZERO

func get_outside_cord() -> Vector2:
	return inside_cord + direction

# cord inside map
func get_map_inside_cord() -> Vector2:
	return parent_room.cord + inside_cord

func get_map_outside_cord() -> Vector2:
	return parent_room.cord + get_outside_cord()

# other
func room_connected() -> bool:
	if connected_room != null:
		return true
	
	return false

func set_closed(value:bool) -> void:
	if closed == value:
		return
	
	closed = value
	if closed:
		emit_signal("connection_closed")
	else:
		emit_signal("connection_opened")
