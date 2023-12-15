extends Level
class_name PrologLevel

func set_up(args:Array = []) -> void:
	create_level(Vector2(6,4))
	
	var start_prolog_room:RoomData = RoomData.new().set_up("start_prolog_room")
	var dash_prolog_room:RoomData = RoomData.new().set_up("dash_prolog_room")
	var trap_prolog_room:RoomData = RoomData.new().set_up("trap_prolog_room")
	var kill_prolog_room:RoomData = RoomData.new().set_up("kill_prolog_room")
	var teleport_prolog_room:RoomData = RoomData.new().set_up("teleport_prolog_room")
	var end_prolog_room:RoomData = RoomData.new().set_up("end_prolog_room")
	
	place_room(start_prolog_room, Vector2(0,0))
	place_room(dash_prolog_room, Vector2(1,0))
	place_room(trap_prolog_room, Vector2(3,0))
	place_room(kill_prolog_room, Vector2(3,2))
	place_room(teleport_prolog_room, Vector2(4,2))
	place_room(end_prolog_room, Vector2(5,3))
	
	start_prolog_room.connect_room(dash_prolog_room, start_prolog_room.connection_arry[0])
	dash_prolog_room.connect_room(trap_prolog_room, dash_prolog_room.connection_arry[0])
	trap_prolog_room.connect_room(kill_prolog_room, trap_prolog_room.connection_arry[0])
	kill_prolog_room.connect_room(teleport_prolog_room, kill_prolog_room.connection_arry[0])
	teleport_prolog_room.connect_room(end_prolog_room, teleport_prolog_room.connection_arry[0])
	
	# Spawn map
	default_room = spawn_room(start_prolog_room)
	currnet_active_room = default_room
	
	spawn_room(dash_prolog_room)
	spawn_room(trap_prolog_room)
	spawn_room(kill_prolog_room)
	spawn_room(teleport_prolog_room)
	spawn_room(end_prolog_room)
	
	print_number_map()
	
	# Set Player
	GameManager.player.position = Vector2(800, 640)
	GameManager.dialog_box.play("first_time_prolog")
