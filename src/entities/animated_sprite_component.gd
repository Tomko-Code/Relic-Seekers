class_name AnimatedSpriteComponent
extends Node2D

var current_animation = ""

@export var _MovementComponent: MovementComponent
@export var _ShootingComponent: ShootingComponent


func _process(delta):
	handle_entity_animation()


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


func set_animation(animation):
	if current_animation != animation:
		for sprite in get_children():
			if sprite is AnimatedSprite2D and sprite.sprite_frames.has_animation(animation):
				sprite.play(animation)
				sprite.set_frame_and_progress(1,0)
				current_animation = animation


func handle_entity_animation():
	if _MovementComponent:
		if _ShootingComponent:
			handle_animated_sprite_with_direction()
		else:
			handle_animated_sprite_without_direction()
		


func handle_animated_sprite_without_direction():
	if _MovementComponent.is_idle:
		set_animation("idle")
	else:
		if _MovementComponent.get_direction().x < 0:
			set_animation("move_left")
		elif _MovementComponent.get_direction().x > 0:
			set_animation("move_right")
		elif _MovementComponent.get_direction().y < 0:
			set_animation("move_up")
		elif _MovementComponent.get_direction().y > 0:
			set_animation("move_down")
	if _MovementComponent.is_rotable:
		rotation = _MovementComponent.get_direction().angle()
	

func handle_animated_sprite_with_direction():
	match get_direction_constant(_ShootingComponent.get_direction()):
		Constants.all_directions.RIGHT:
			set_animation("move_right")
		Constants.all_directions.RIGHT_UP:
			set_animation("move_up_right")
		Constants.all_directions.UP:
			set_animation("move_up")
		Constants.all_directions.LEFT_UP:
			set_animation("move_left_up")
		Constants.all_directions.LEFT:
			set_animation("move_left")
		Constants.all_directions.LEFT_DOWN:
			set_animation("move_left_down")
		Constants.all_directions.DOWN:
			set_animation("move_down")
		Constants.all_directions.RIGHT_DOWN:
			set_animation("move_right_down")
