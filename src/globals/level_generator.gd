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
	
	# place start room
	place_start()
	
	# add random roooms
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
		
		# TODO : rooms fits
			# TODO : check if room fits in map
			# TODO : change check if room overlaps other room
		
		if room.connection_arry.size() > 0:
			var new_room:RoomData = pick_random_room()
			
			var new_room_inside_cord:Vector2 = Vector2.ZERO
			var open_connection:RoomConnectionData = room.connection_arry.pick_random()
			var new_room_cord:Vector2 = open_connection.get_map_outside_cord()
			
			var valid_connections = has_valid_placement(new_room, open_connection)
			if valid_connections.is_empty():
				continue
			
			var new_room_connection = valid_connections.pick_random()
			new_room_cord -= new_room_connection.inside_cord
			
			level.place_room(new_room, new_room_cord)
			
			# Connect new room
			new_room.connect_room(room, new_room_connection)
			
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
		"l1" : {"rooms" : []},
		"l2" : {"rooms" : []},
		"l3" : {"rooms" : []},
		"l4" : {"rooms" : []}
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
			
		elif room_size.x == 1 and room_size.y == 2: 
			sorted_rooms["1x2"]["rooms"].append(room_name)
			
		elif room_size.x == 2 and room_size.y == 1: 
			sorted_rooms["2x1"]["rooms"].append(room_name)
			
		elif room_size.x == 2 and room_size.y == 2:
			if room_shape[1][1] == 0:
				sorted_rooms["l1"]["rooms"].append(room_name)
			elif room_shape[1][0] == 0:
				sorted_rooms["l2"]["rooms"].append(room_name)
			elif room_shape[0][0] == 0:
				sorted_rooms["l3"]["rooms"].append(room_name)
			elif room_shape[0][1] == 0:
				sorted_rooms["l4"]["rooms"].append(room_name)
			else:
				sorted_rooms["2x2"]["rooms"].append(room_name)

func place_start() -> void:
	var room_data:RoomData = RoomData.new().set_up("start_room", level)
	level.place_room(room_data, level_preset.start_position)
	add_random_connection(room_data)
	rooms.append(room_data)
	rooms_with_open_connections.append(room_data)

func pick_random_set_of_rooms() -> Dictionary:
	return sorted_rooms[sorted_rooms.keys().pick_random()]

func pick_random_room() -> RoomData:
	var set = pick_random_set_of_rooms()
	var room_type = set["rooms"].pick_random()
	return RoomData.new().set_up(room_type, level)

func has_valid_placement(new_room:RoomData, connection:RoomConnectionData) -> Array[RoomConnectionData]:
	var result:Array[RoomConnectionData] = []
	var match_direction:Vector2 = -connection.direction
	
	for possible_connection in new_room.all_possible_connections:
		if match_direction == possible_connection.direction:
			var cord = connection.get_map_outside_cord() - possible_connection.inside_cord
			if not level.is_overlaping(new_room, cord):
				result.append(possible_connection)
	
	return result

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
