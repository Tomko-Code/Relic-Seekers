extends Level
class_name StartLevel

func _init() -> void:
	name = "StartLevel"

func _ready():
	pass
	#remove_child(ambient_light)

func set_up(_args:Array = []) -> void:
	# Set level
	create_level(Vector2(1,1))
	
	# Set Rooms
	var room:RoomData = RoomData.new().set_up("swamp_room", self)
	place_room(room, Vector2(0,0))
	
	# Spawn map
	default_room = spawn_room(room)
	currnet_active_room = default_room
	
	# Set Player
	#GameManager.player.glo = Vector2(2545.0, 2580.0)
	player_spawn_pos = default_room.get_node("Marker2D").position
	GameManager.player.paused = true
	
	print_number_map()
