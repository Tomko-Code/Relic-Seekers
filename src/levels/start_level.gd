extends Level
class_name StartLevel

func set_up(args:Array = []) -> void:
	# Set level
	create_level(Vector2(1,1))
	
	remove_child(ambient_light)
	
	# Set Rooms
	var room:RoomData = RoomData.new().set_up("swamp_room", self)
	place_room(room, Vector2(0,0))
	
	# Spawn map
	default_room = spawn_room(room)
	currnet_active_room = default_room
	
	# Set Player
	GameManager.player.position = Vector2(550, 350)
	GameManager.player.paused = true
	
	print_number_map()
