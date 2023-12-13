extends Node2D
class_name Room

var data:RoomData

@export var floors:TileMap
@export var walls:TileMap

# Snail Code
var snail_start_cord:Vector2 = Vector2.ZERO
var snail_cord:Vector2 = Vector2.ZERO
var snail_direction:Vector2 = Vector2.LEFT

var snail_start:Vector2 = Vector2(-1,-1)
var snail_end:Vector2 = Vector2(0,0)

var change_budiers:bool = true

var minimum_distance:float = 192.0

func look_for_open_space(starting_position:Vector2) -> Vector2:
	snail_start_cord = (starting_position/Constants.FLOOR_TILE_SIZE).floor()
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
			return cord
	
	reset_snail()
	return Vector2.ZERO

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
