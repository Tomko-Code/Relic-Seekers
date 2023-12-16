class_name FourDirectionAnimationSystem
extends Node

#required
@export var _MovementComponent: MovementComponent
@export var _ShootingComponent: ShootingComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent


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
	if _MovementComponent:
		if _MovementComponent.is_idle:
			_AnimatedSpriteComponent.set_animation("idle")
		else:
			if _MovementComponent.get_direction().x < 0:
				_AnimatedSpriteComponent.set_animation("move_left")
			elif _MovementComponent.get_direction().x > 0:
				_AnimatedSpriteComponent.set_animation("move_right")
			elif _MovementComponent.get_direction().y < 0:
				_AnimatedSpriteComponent.set_animation("move_up")
			elif _MovementComponent.get_direction().y > 0:
				_AnimatedSpriteComponent.set_animation("move_down")
		if _MovementComponent.is_rotable:
			_AnimatedSpriteComponent.rotation = _MovementComponent.get_direction().angle()
	elif _ShootingComponent:
		match get_direction_constant(_ShootingComponent.get_direction()):
			Constants.all_directions.RIGHT:
				_AnimatedSpriteComponent.set_animation("idle_right")
			Constants.all_directions.LEFT:
				_AnimatedSpriteComponent.set_animation("idle_left")
			Constants.all_directions.DOWN:
				_AnimatedSpriteComponent.set_animation("idle_down")
			Constants.all_directions.UP:
				_AnimatedSpriteComponent.set_animation("idle_up")
