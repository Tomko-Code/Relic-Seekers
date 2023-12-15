extends Node2D
class_name Room

signal player_enterd

var data:RoomData

@export var floors:TileMap
@export var walls:TileMap
@export var Gates:Node2D

var spawn_point_res = preload("res://src/other/spawner_point/spawner_point.tscn")

# Enemies
var enemies_cleard:bool = true
var enemy_count:int = 0 : set = set_enemy_count
var wave_it:int = 0

# Snail Code
var snail_start_cord:Vector2 = Vector2.ZERO
var snail_cord:Vector2 = Vector2.ZERO
var snail_direction:Vector2 = Vector2.LEFT

var snail_start:Vector2 = Vector2(-1,-1)
var snail_end:Vector2 = Vector2(0,0)

var change_budiers:bool = true

var minimum_distance:float = 192.0

func set_enemy_count(value:int):
	enemy_count = value
	if enemy_count > 0:
		# close room or do nothing
		pass
	else:
		if data.has_waves:
			spawn_next_wave()
		else:
			pass
		# open room or spawn next wave

func look_for_open_space(starting_position:Vector2) -> Vector2:
	starting_position -= (data.cord*5*Vector2(5,4))*Vector2(64,64)
	
	snail_start_cord = (starting_position/Constants.FLOOR_TILE_SIZE).floor()
	#snail_start_cord += (data.cord*5*Vector2(5,4))
	var found:bool = false
	var closet_best_cord:Vector2
	var smallest_distance:float = -1
	
	while not found:
		var cord = get_next_snail_cord()
		var cord_position = (cord*Constants.FLOOR_TILE_SIZE) + (Constants.FLOOR_TILE_SIZE/2)
		var distance = cord_position.distance_to(starting_position)
		var wall_cord = (cord_position/Constants.WALL_TILE_SIZE).floor()
		
		var correct_distance = (distance > minimum_distance)
		var not_pit = (floors.get_cell_tile_data(1, cord) == null)
		var not_wall = (walls.get_cell_tile_data(0, wall_cord) == null)
		
		if correct_distance and not_pit and not_wall:
			reset_snail()
			return cord + (data.cord*5*Vector2(5,4))
	
	reset_snail()
	return Vector2.ZERO

func get_rand_cord_inside() -> Vector2:
	var room_size = data.get_room_size()
	var room_floor_size = room_size * (Vector2(5,4) * 5)
	return Vector2( randi_range(6, room_floor_size.x - 6), randi_range(6, room_floor_size.y - 6)) 

func get_random_free_spot(max_test:int = 1000) -> Vector2:
	while max_test > 0:
		var rand_cord = get_rand_cord_inside()
		
		# test for 3x3 area
		if (is_this_spot_free(rand_cord) and
			is_this_spot_free(rand_cord + Vector2(0, 1)) and
			is_this_spot_free(rand_cord + Vector2(1, 1)) and
			is_this_spot_free(rand_cord + Vector2(-1, 1)) and
			is_this_spot_free(rand_cord + Vector2(0, -1)) and
			is_this_spot_free(rand_cord + Vector2(1, -1)) and
			is_this_spot_free(rand_cord + Vector2(-1, -1)) and
			is_this_spot_free(rand_cord + Vector2(1, 0)) and
			is_this_spot_free(rand_cord + Vector2(-1, 0))):
			return rand_cord
		max_test -= 1
	
	return Vector2.INF

func is_this_spot_free(_cord:Vector2) -> bool:
	var cord = _cord
	var cord_position = (cord*Constants.FLOOR_TILE_SIZE) + (Constants.FLOOR_TILE_SIZE/2)

	var wall_cord = (cord_position/Constants.WALL_TILE_SIZE).floor()
	
	var not_pit = (floors.get_cell_tile_data(1, cord) == null)
	var not_wall = (walls.get_cell_tile_data(0, wall_cord) == null)
	
	return not_pit and not_wall

func reset_snail() -> void:
	snail_start_cord = Vector2.ZERO
	
	snail_cord = Vector2.ZERO
	snail_direction = Vector2.LEFT
	
	snail_start = Vector2(-1,-1)
	snail_end = Vector2(0,0)
	
	change_budiers = true

func change_snail_direction() -> void:
	match snail_direction:
		Vector2.LEFT:
			snail_direction = Vector2.UP
		Vector2.UP:
			snail_direction = Vector2.RIGHT
		Vector2.RIGHT:
			if change_budiers:
				snail_start -= Vector2(1,1)
				snail_end += Vector2(1,1)
				change_budiers = false
			else:
				snail_direction = Vector2.DOWN
		Vector2.DOWN:
			change_budiers = true
			snail_direction = Vector2.LEFT

func get_next_snail_cord() -> Vector2:
	if snail_cord.x + snail_direction.x > snail_end.x:
		change_snail_direction()
	elif snail_cord.x + snail_direction.x < snail_start.x:
		change_snail_direction()
	elif snail_cord.y + snail_direction.y < snail_start.y:
		change_snail_direction()
	elif snail_cord.y + snail_direction.y > snail_end.y:
		change_snail_direction()
	
	snail_cord += snail_direction
	return snail_cord + snail_start_cord

func spawn_wave() -> void:
	var wave = data.waves[wave_it]
	for part in wave:
		var spawn_amout = randi_range(part[0], part[1])
		
		for spawn in range(spawn_amout):
			var cord:Vector2 = get_random_free_spot()
			if cord == Vector2.INF:
				continue
			
			var pos:Vector2 = cord * Constants.FLOOR_TILE_SIZE
			
			var enemy:Enemy = EnemiesHandler.spawn_enemy(part[2].pick_random())
			enemy_count += 1
			enemy.death.connect(on_enemy_death)
			enemy.position = pos
			
			var spawn_point:SpawnerPoint = spawn_point_res.instantiate()
			spawn_point.position = pos
			spawn_point.enemy = enemy
			spawn_point.room = self
			
			call_deferred("add_child", spawn_point)

func on_enemy_death():
	enemy_count -= 1

func spawn_next_wave() -> void:
	if wave_it < data.waves.size():
		spawn_wave()
		wave_it += 1
	else:
		data.has_waves = false

func on_player_enter() -> void:
	if data.has_waves:
		spawn_next_wave()
	
	emit_signal("player_enterd")
