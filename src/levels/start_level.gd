extends Level
class_name StartLevel

func set_up(args:Array = []) -> void:
	# Set level
	create_level(Vector2(1,1))
	
	# Set Room
	var room:RoomData = RoomData.new().set_up("swamp_room")
	place_room(room, Vector2(0,0))
	spawn_room(room)
	
	# Set Player
	GameManager.player.position = Vector2(550, 350)
	GameManager.player.paused = true
	
	print_number_map()
