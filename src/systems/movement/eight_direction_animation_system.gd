class_name EightDirectionMovementSystem
extends Node

#required
@export var _MovementComponent: MovementComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent

#optional
@export var _ShootingComponent: ShootingComponent


func get_direction_constant(vector: Vector2):
	var final_angle = PI/4*(8) + PI/8
	for x in range(9):
		var next_angle = (PI/4)*(8-x) + PI/8
		if final_angle == (PI/4)*(8) + PI/8:
			
			var vector_angle = vector.angle()
			if vector_angle < 0:
				vector_angle += 2*PI
				
			if vector_angle >= next_angle:
				final_angle = next_angle
				return x-1
	return Constants.all_directions.RIGHT


func _process(delta):
	if _ShootingComponent:
		match get_direction_constant(_ShootingComponent.get_direction()):
			Constants.all_directions.RIGHT:
				_AnimatedSpriteComponent.set_animation("move_right")
			Constants.all_directions.RIGHT_UP:
				_AnimatedSpriteComponent.set_animation("move_up_right")
			Constants.all_directions.UP:
				_AnimatedSpriteComponent.set_animation("move_up")
			Constants.all_directions.LEFT_UP:
				_AnimatedSpriteComponent.set_animation("move_left_up")
			Constants.all_directions.LEFT:
				_AnimatedSpriteComponent.set_animation("move_left")
			Constants.all_directions.LEFT_DOWN:
				_AnimatedSpriteComponent.set_animation("move_left_down")
			Constants.all_directions.DOWN:
				_AnimatedSpriteComponent.set_animation("move_down")
			Constants.all_directions.RIGHT_DOWN:
				_AnimatedSpriteComponent.set_animation("move_right_down")
	if _MovementComponent.is_rotable:
		_AnimatedSpriteComponent.rotation = _MovementComponent.get_direction().angle()
