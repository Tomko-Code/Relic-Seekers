@tool
extends PointLight2D

@export var direction:Constants.cross_directions : 
	set(value):
		direction = value
		
		match direction:
			Constants.cross_directions.UP:
				vec_direction = Vector2.UP

			Constants.cross_directions.DOWN:
				vec_direction = Vector2.DOWN
				
			Constants.cross_directions.LEFT:
				vec_direction = Vector2.LEFT
				
			Constants.cross_directions.RIGHT:
				vec_direction = Vector2.RIGHT
				
		rotation = vec_direction.angle() - Vector2.UP.angle()

var vec_direction:Vector2 = Vector2.UP

func _ready():
	rotation = vec_direction.angle() - Vector2.UP.angle()
