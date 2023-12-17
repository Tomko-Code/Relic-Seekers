extends Level
class_name ShowLevel

func set_up(args:Array = []) -> void:
	create_level(Vector2(10,10))
	
	var show_room:RoomData = RoomData.new().set_up("show_room")
	
	place_room(show_room, Vector2(3,3))

	#print(room2.get_connection( room1.connection_arry[0].get_map_outside_cord(), -room1.connection_arry[0].direction))
	
	print_number_map()
	
	# Spawn map
	default_room = spawn_room(show_room)
	currnet_active_room = default_room
	
	# Set Player
	GameManager.player.position = get_cord_center_position((show_room.cord))
