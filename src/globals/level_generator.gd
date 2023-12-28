extends Node
# Global

var sorted_rooms: Dictionary
var level:Level
var level_preset:LevelGenerationPreset

var open_connections:Array[RoomConnectionData]

var rooms:Array[RoomData]
var rooms_with_open_connections:Array[RoomData]

func generate(_level_preset:LevelGenerationPreset) -> Level:
	level_preset = _level_preset
	start_generator()
	
	print("Used sets : " + str(level_preset.room_sets))
	compile_rooms()
	
	print("Rooms : ")
	for type in sorted_rooms:
		print(type + " : " + str(sorted_rooms[type]["rooms"]))
	
	level.create_level(level_preset.level_size)
	
	# place start
	place_start()
	
	# add random rooom
	var try_cout = 0
	while rooms.size() < level_preset.min_rooms:
		try_cout += 1
		var room = null
		
		if !rooms_with_open_connections.is_empty():
			room = rooms_with_open_connections.pick_random()
		
		if try_cout > 5:
			
			print("add conn")
			add_more_connections() # to a random room
		
		if try_cout > 100:
			break
		
		if room == null: # might be no more rooms with open connections
			continue
		
		if room.connection_arry.size() > 0:
			var new_room:RoomData = RoomData.new().set_up("1x1_small", level)
			
			var open_connection = room.connection_arry.pick_random()
			var room_cord = open_connection.get_map_outside_cord()
			
			if level.is_overlaping(new_room, room_cord):
				continue
			
			level.place_room(new_room, room_cord)
			
			# Connect new room
			var test_conn = new_room.add_connection(room_cord - new_room.cord, -open_connection.direction)
			new_room.connect_room(room, test_conn)
			
			add_random_connections_to_new_room(new_room)
			
			rooms.append(new_room)
			
			if new_room.connection_arry.size() > 0:
				if !rooms_with_open_connections.has(new_room):
					rooms_with_open_connections.append(new_room)
			else:
				if rooms_with_open_connections.has(new_room):
					rooms_with_open_connections.erase(new_room)
			
			if room.connection_arry.size() > 0:
				if !rooms_with_open_connections.has(room):
					rooms_with_open_connections.append(room)
			else:
				if rooms_with_open_connections.has(room):
					rooms_with_open_connections.erase(room)
			
			try_cout = 0
			
	# add special rooms
	
	# Spawn physical level
	spawn_level()
	
	print("Generating ended.")
	print("|-------------------|")
	return level

func start_generator() -> void:
	level = Level.new()
	level.name = level_preset.level_name
	open_connections = []
	rooms_with_open_connections = []
	rooms = []
	
	sorted_rooms = {
		"1x1": {"rooms" : []},
		"1x2": {"rooms" : []},
		"2x1": {"rooms" : []},
		"2x2": {"rooms" : []},
		"L1" : {"rooms" : []},
		"L2" : {"rooms" : []},
		"L3" : {"rooms" : []},
		"L4" : {"rooms" : []}
	}

func compile_rooms() -> void:
	for room_set in level_preset.room_sets:
		sort_rooms_by_shape(room_set)

func sort_rooms_by_shape(rooms_set:String) -> void:
	for room_name in GameData.room_sets[rooms_set]:
		var room_shape:Array = GameData.rooms_data[room_name]["shape"]
		var room_size:Vector2 = Vector2(room_shape[0].size(), room_shape.size())
		
		if room_size.x == 1 and room_size.y == 1:
			sorted_rooms["1x1"]["rooms"].append(room_name)

func place_start() -> void:
	var room_data:RoomData = RoomData.new().set_up("start_room", level)
	level.place_room(room_data, level_preset.start_position)
	add_random_connection(room_data)
	rooms.append(room_data)
	rooms_with_open_connections.append(room_data)

func add_more_connections() -> void:
	var room_tmp = rooms.pick_random()
	add_random_connection(room_tmp)
	if room_tmp.connection_arry.size() > 0:
		if !rooms_with_open_connections.has(room_tmp):
			rooms_with_open_connections.append(room_tmp)
	else:
		if rooms_with_open_connections.has(room_tmp):
			rooms_with_open_connections.erase(room_tmp)

func add_random_connections_to_new_room(room:RoomData) -> void:
	#add_random_connection(room)
	#add_random_connection(room)
	#add_random_connection(room)
	
	while room.connection_arry.size() < 1:
		add_random_connection(room)

func add_random_connection(room_data:RoomData) -> bool:
	var random_conn:RoomConnectionData = room_data.get_random_connection()
	if random_conn == null:
		return false
	
	var cord_outside:Vector2 = random_conn.inside_cord + room_data.cord + random_conn.direction
	
	if level.cord_outside_map(cord_outside):
		return false
	
	room_data.add_connection(random_conn.inside_cord, random_conn.direction)
	return true

func spawn_level() -> void:
	for unspawned_room in range(level.unspawned_rooms.size()):
		level.spawn_room(level.unspawned_rooms[0])

func get_random_direction() -> Vector2:
	var random_number = randi()% 4
	
	match random_number:
		0: return Vector2.UP
		1: return Vector2.DOWN
		2: return Vector2.LEFT
		3: return Vector2.RIGHT
	
	return Vector2.ZERO
