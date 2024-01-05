extends Node
# Global

class PlacementRoomData extends RefCounted:
	var room_type:String = ""
	var room_weight:float = 0.0
	var min_range:float
	var max_range:float
	
	var placement_count:int = 0

var sorted_rooms: Dictionary
var rooms_placement_info: Array[PlacementRoomData]
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
	var boss_added = false
	var end_added = false
	var special_rooms_added = false
	
	var boss_room = RoomData.new().set_up("test_boss_room", level)
	var end_room = RoomData.new().set_up("end_room", level)
	boss_room.is_special = true
	boss_room.is_boss = true
	end_room.is_special = true
	end_room.is_end = true
	
	var special_rooms:Dictionary = level_preset.special_rooms.duplicate(true)
	
	while true:
		try_cout += 1
		var room = null
		
		if !rooms_with_open_connections.is_empty():
			room = rooms_with_open_connections.pick_random()
		
		if try_cout > 5:
			add_more_connections() # to a random room
		
		if try_cout > 100:
			print("Generating fail.")
			return null
		
		if room == null: # might be no more rooms with open connections
			continue
		
		# TODO :
			# TODO : trim bad connections
		
		if rooms.size() < level_preset.min_rooms:
			if room.connection_arry.size() > 0:
				#var new_room:RoomData = pick_random_room()
				#var new_room:RoomData = pick_random_room_by_weight()
				var new_room:RoomData = pick_room()
				if add_room(room, new_room):
					try_cout = 0
		elif not boss_added:
			if room.distance_from_start <= 1:
					continue
			
			if room.connection_arry.size() > 0:
				if add_room(room, boss_room):
					try_cout = 0
					boss_added = true
					while not boss_room.all_possible_connections.is_empty():
						add_random_connection(boss_room)
		elif not end_added:
			if add_room(boss_room, end_room, true):
				end_added = true
			else:
				print("Exit placment fail !")
				return null
		elif not special_rooms_added:
			if room.connection_arry.size() > 0:
				if special_rooms.is_empty():
					special_rooms_added = true
					continue
				
				var type = special_rooms.keys()[0]
				var new_room:RoomData = RoomData.new().set_up(type, level)
				new_room.is_special = true
				
				if room.is_special:
					continue
				
				if add_room(room, new_room):
					try_cout = 0
					special_rooms[type]["count"] -= 1
					
					if special_rooms[type]["count"] == 0:
						special_rooms.erase(type)
					
					if special_rooms.is_empty():
						special_rooms_added = true
			
		if special_rooms_added == true:
			break
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
	rooms_placement_info = []
	
	sorted_rooms = {
		"1x1": {"rooms" : [], "weight" : 150, "base_room_weight" : 150, "min_range" : 0.0, "max_range" : 0.0, "total_weight": 0},
		"1x2": {"rooms" : [], "weight" : 20, "base_room_weight" : 20, "min_range" : 0.0, "max_range" : 0.0, "total_weight": 0},
		"2x1": {"rooms" : [], "weight" : 20, "base_room_weight" : 20, "min_range" : 0.0, "max_range" : 0.0, "total_weight": 0},
		"2x2": {"rooms" : [], "weight" : 25, "base_room_weight" : 25, "min_range" : 0.0, "max_range" : 0.0, "total_weight": 0},
		"l1" : {"rooms" : [], "weight" : 10, "base_room_weight" : 15, "min_range" : 0.0, "max_range" : 0.0, "total_weight": 0},
		"l2" : {"rooms" : [], "weight" : 10, "base_room_weight" : 15, "min_range" : 0.0, "max_range" : 0.0, "total_weight": 0},
		"l3" : {"rooms" : [], "weight" : 10, "base_room_weight" : 15, "min_range" : 0.0, "max_range" : 0.0, "total_weight": 0},
		"l4" : {"rooms" : [], "weight" : 10, "base_room_weight" : 15, "min_range" : 0.0, "max_range" : 0.0, "total_weight": 0}
	}

func compile_rooms() -> void:
	var total_weight:float = 0.0
	var total_weight_set:float = 0.0
	for room_set in level_preset.room_sets:
		sort_rooms_by_shape(room_set)

	for key in sorted_rooms:
		total_weight_set += level_preset.shape_weights[key]
		
		for room in sorted_rooms[key]["rooms"]:
			var placemen_data:PlacementRoomData = PlacementRoomData.new()
			placemen_data.room_type = room
			
			if GameData.rooms_data[room].has("custom_weight"):
				placemen_data.room_weight = GameData.rooms_data[room]["custom_weight"]
			else:
				placemen_data.room_weight = sorted_rooms[key]["base_room_weight"]
			
			#placemen_data.room_weight *= sorted_rooms[key]["weight_multiplayer"]
			
			total_weight += placemen_data.room_weight
			sorted_rooms[key]["total_weight"] += placemen_data.room_weight
			
			rooms_placement_info.append(placemen_data)
	
	var to_clean:Array = []
	
	var max_range:float = 0.0
	var max_range_set:float = 0.0
	for key in sorted_rooms:
		if sorted_rooms[key]["total_weight"] == 0:
			to_clean.append(key)
			continue
		
		var weight_to_float:float = sorted_rooms[key]["total_weight"] / total_weight
		sorted_rooms[key]["min_range"] = max_range
		
		max_range += weight_to_float
		sorted_rooms[key]["max_range"] = max_range
		
		# Setthis is terrible code XD
		weight_to_float = level_preset.shape_weights[key] / total_weight_set
		sorted_rooms[key]["set_min_range"] = max_range_set
		
		max_range_set += weight_to_float
		sorted_rooms[key]["set_max_range"] = max_range_set
	
	for key in to_clean:
		sorted_rooms.erase(key)
	
	#print("Total weight : " + str(total_weight))
	
	
	max_range = 0.0
	for room in rooms_placement_info:
		var weight_to_float:float = room.room_weight / total_weight
		room.min_range = max_range
		
		max_range += weight_to_float
		room.max_range = max_range
		
		#print(max_range)

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
	room_data.is_start = true
	if level_preset.random_start:
		level_preset.start_position.x = randi_range(0, level_preset.level_size.x - 1)
		level_preset.start_position.x = randi_range(0, level_preset.level_size.y - 1)
	level.place_room(room_data, level_preset.start_position)
	add_random_connection(room_data)
	rooms.append(room_data)
	room_data.is_special = true
	rooms_with_open_connections.append(room_data)

func add_room(from:RoomData, new_room:RoomData, try_all_possible:bool = false) -> bool:
		#var new_room:RoomData = pick_random_room()
	#var new_room:RoomData = pick_random_room_by_weight()
	
	var new_room_inside_cord:Vector2 = Vector2.ZERO
	var open_connection:RoomConnectionData
	var valid_connections
	
	if try_all_possible:
		for conn in from.connection_arry:
			open_connection = conn
			valid_connections = has_valid_placement(new_room, open_connection)
			#print("valid_connections size : " + str(valid_connections.size()))
			if not valid_connections.is_empty():
				break
	else:
		open_connection = from.connection_arry.pick_random()
		valid_connections = has_valid_placement(new_room, open_connection)
		#print("valid_connections size : " + str(valid_connections.size()))
	
	if valid_connections.is_empty():
		return false
	
	var new_room_cord:Vector2 = open_connection.get_map_outside_cord()
	
	var new_room_connection = valid_connections.pick_random()
	new_room_cord -= new_room_connection.inside_cord
			
	level.place_room(new_room, new_room_cord)
			
			# Connect new room
	new_room.connect_room(from, new_room_connection)
	
	add_random_connections_to_new_room(new_room)
	
	rooms.append(new_room)
	
	new_room.distance_from_start = from.distance_from_start + 1
	
	if new_room.connection_arry.size() > 0:
		if !rooms_with_open_connections.has(new_room):
			rooms_with_open_connections.append(new_room)
	else:
		if rooms_with_open_connections.has(new_room):
			rooms_with_open_connections.erase(new_room)
			
	if from.connection_arry.size() > 0:
		if !rooms_with_open_connections.has(from):
			rooms_with_open_connections.append(from)
	else:
		if rooms_with_open_connections.has(from):
			rooms_with_open_connections.erase(from)
	
	return true

func pick_random_set_of_rooms() -> Dictionary:
	return sorted_rooms[sorted_rooms.keys().pick_random()]

func pick_room() -> RoomData:
	match level_preset.room_randomize_setting:
		LevelGenerationPreset.ROOM_RANOMIZE_SETTINGS.BY_SHAPE_ROOM_WEIGHT:
			var shape_dic:Dictionary = pick_random_set_by_weight()
			var min_room_weight:float = shape_dic["min_range"]
			var max_room_weight:float = shape_dic["max_range"]
			
			return pick_random_room_by_weight(min_room_weight, max_room_weight)
	
	return null

func pick_random_room() -> RoomData:
	var set = pick_random_set_of_rooms()
	var room_type = set["rooms"].pick_random()
	return RoomData.new().set_up(room_type, level)

func pick_random_set_by_weight() -> Dictionary:
	var random_weight:float = randf()
	for key in sorted_rooms:
		var in_max_range:bool = random_weight <= sorted_rooms[key]["set_max_range"]
		var in_min_range:bool = random_weight >= sorted_rooms[key]["set_min_range"]
		
		if in_max_range and in_min_range:
			return sorted_rooms[key]
	
	return {}

func place_boss_room():
	pass

func place_end_room():
	pass

func pick_random_room_by_weight(min:float = 0.0, max:float = 1.0) -> RoomData:
	var random_weight:float = randf_range(min, max)
	var it:int = (rooms_placement_info.size() - 1)/2
	var min_it:int = 0
	var max_it:int = rooms_placement_info.size() - 1
	
	while not room_weight_in_range(rooms_placement_info[it], random_weight):
		if random_weight > rooms_placement_info[it].max_range:
			min_it = it
		else:
			max_it = it
		
		it = (min_it + max_it)/2
		
		if (max_it - min_it) == 1:
			if room_weight_in_range(rooms_placement_info[min_it], random_weight):
				it = min_it
			
			if room_weight_in_range(rooms_placement_info[max_it], random_weight):
				it = max_it
			
			break
	
	#print(it)
	#print(rooms_placement_info[it].room_weight)
	
	return RoomData.new().set_up(rooms_placement_info[it].room_type, level)

func room_weight_in_range(data:PlacementRoomData, weight:float) -> bool:
	var in_max_range:bool = weight <= data.max_range
	var in_min_range:bool = weight >= data.min_range
	#print(weight)
	#print(data.min_range)
	#print(data.max_range)
	#print( in_max_range and in_min_range)
	return  in_max_range and in_min_range
	

func fits_on_the_map(room_data:RoomData, cord:Vector2) -> bool:
	var fits_on_map:bool = true
	for y in range(room_data.room_shape.size()):
		for x in range(room_data.room_shape[0].size()):
			if room_data.room_shape[y][x] == 1:
				if level.cord_outside_map(cord + Vector2(x,y)):
					return false
	return true

func has_valid_placement(new_room:RoomData, connection:RoomConnectionData) -> Array[RoomConnectionData]:
	var result:Array[RoomConnectionData] = []
	var match_direction:Vector2 = -connection.direction
	
	for possible_connection in new_room.all_possible_connections:
		if match_direction == possible_connection.direction:
			var cord = connection.get_map_outside_cord() - possible_connection.inside_cord
			
			if !fits_on_the_map(new_room, cord):
				continue
			
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
		room_data.all_possible_connections.erase(random_conn)
		return false
	
	room_data.add_connection(random_conn.inside_cord, random_conn.direction)
	return true

func spawn_level() -> void:
	for unspawned_room in range(level.unspawned_rooms.size()):
		var room:Room = level.spawn_room(level.unspawned_rooms[0])
		
		if room.data.is_start == true:
			level.default_room = room
			level.player_spawn_pos = room.position + (Constants.CHUNK_SIZE/2)
			level.currnet_active_room = level.default_room

func get_random_direction() -> Vector2:
	var random_number = randi()% 4
	
	match random_number:
		0: return Vector2.UP
		1: return Vector2.DOWN
		2: return Vector2.LEFT
		3: return Vector2.RIGHT
	
	return Vector2.ZERO
