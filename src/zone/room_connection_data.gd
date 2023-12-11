extends RefCounted
class_name RoomConnectionData

var connected_room:RoomData = null
var parent_room:RoomData = null

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
