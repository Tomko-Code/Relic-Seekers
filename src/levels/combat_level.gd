extends Level
class_name CombatLevel

func set_up(args:Array = []) -> void:
	create_level(Vector2(10,10))
	
	var main_combat_room:RoomData = RoomData.new().set_up("main_combat_room", self)
	var left_combat_room:RoomData = RoomData.new().set_up("left_combat_room", self)
	
	place_room(main_combat_room, Vector2(3,3))
	place_room(left_combat_room, Vector2(2,4))
	#print(room2.get_connection( room1.connection_arry[0].get_map_outside_cord(), -room1.connection_arry[0].direction))

	# crates both way connection
	left_combat_room.connect_room(main_combat_room, left_combat_room.connection_arry[0])
	
	print_number_map()
	
	# Spawn map
	default_room = spawn_room(main_combat_room)
	currnet_active_room = default_room
	
	spawn_room(left_combat_room)
	
	# Set Player
	custom_spawn = true
	GameManager.player.position = get_cord_center_position((main_combat_room.cord)+Vector2(0,1))
