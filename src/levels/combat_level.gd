extends Level
class_name CombatLevel

func set_up(args:Array = []) -> void:
	create_level(Vector2(10,10))
	
	var room1:RoomData = RoomData.new().set_up("Start")
	var room2:RoomData = RoomData.new().set_up("Normal1")
	
	place_room(room1, Vector2(0,1))
	place_room(room2, Vector2(0,0))
	
	#print(room2.get_connection( room1.connection_arry[0].get_map_outside_cord(), -room1.connection_arry[0].direction))
	#print(room1.get_connection( room2.connection_arry[0].get_map_outside_cord(), -room2.connection_arry[0].direction))
	
	# crates both way connection
	room1.connect_room(room2, room1.connection_arry[0])
	
	print_number_map()
	
	# Spawn map
	default_room = spawn_room(room1)
	spawn_room(room2)
	
	currnet_active_room = default_room
	
	# Set Player
	GameManager.player.position = get_cord_center_position(room1.cord)


