class_name FourDirectionMovementSystemExtra
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
	var animation_direction
	if _ShootingComponent:
		animation_direction = get_direction_constant(_ShootingComponent.get_direction())
	else:
		animation_direction = get_direction_constant(_MovementComponent.get_direction())
	
	match animation_direction:
		Constants.all_directions.RIGHT:
			#_AnimatedSpriteComponent.set_animation("move_right")
			#if _AnimatedSpriteComponent.current_animation not in ["move_right_down", "move_up_right"]:
			#	_AnimatedSpriteComponent.set_animation("move_right_down")
			set_animation("right_down")
		Constants.all_directions.RIGHT_UP:
			set_animation("up_right")
		Constants.all_directions.UP:
			#_AnimatedSpriteComponent.set_animation("move_up")
			if _AnimatedSpriteComponent.current_animation not in ["move_left_up", "move_up_right"] or _MovementComponent.is_idle:
				set_animation("left_up")
		Constants.all_directions.LEFT_UP:
			set_animation("left_up")
		Constants.all_directions.LEFT:
			#_AnimatedSpriteComponent.set_animation("move_left")
			set_animation("left_down")
		Constants.all_directions.LEFT_DOWN:
			set_animation("left_down")
		Constants.all_directions.DOWN:
			#_AnimatedSpriteComponent.set_animation("move_down")
			if _AnimatedSpriteComponent.current_animation not in ["move_right_down", "move_left_down"] or _MovementComponent.is_idle:
				set_animation("left_down")
		Constants.all_directions.RIGHT_DOWN:
			set_animation("right_down")
				
	if _MovementComponent.is_rotable:
		_AnimatedSpriteComponent.rotation = _MovementComponent.get_direction().angle()


func set_animation(animation: String):
	var animation_direction = 1
	if _ShootingComponent:
		var movment_direction = get_direction_constant(_ShootingComponent.get_direction())
		var mouse_direction = get_direction_constant(_MovementComponent.get_direction())
		
		if abs(movment_direction - mouse_direction) in [3,4,5]:
			animation_direction = -1
	
	if _MovementComponent.is_idle:
		_AnimatedSpriteComponent.set_animation("idle_" + animation, animation_direction)
	else:
		_AnimatedSpriteComponent.set_animation("move_" + animation, animation_direction)
