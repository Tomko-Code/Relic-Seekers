extends Level
class_name SanctuaryLevel

func set_up(args:Array = []) -> void:
	### basic
	level_activated.connect(on_level_activated)
	
	### map
	create_level(Vector2(1,1))
	
	var sanctuary_room:RoomData = RoomData.new().set_up("sanctuary_room", self)
	place_room(sanctuary_room, Vector2(0,0))
	
	# Spawn map
	default_room = spawn_room(sanctuary_room)
	currnet_active_room = default_room
	
	print_number_map()

func on_level_activated():
	GameData.save_file.prolog_complete = true
