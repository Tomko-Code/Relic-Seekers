class_name AnimatedSpriteComponent
extends Node2D


var current_animation = ""


func _physics_process(delta):
	#if is_idle:
	#	set_animation("idle")
	#else:
	#	if movement_direction.left:
	#		set_animation("move_left")
	#	elif movement_direction.right:
	#		set_animation("move_right")
	#	elif movement_direction.up:
	#		set_animation("move_up")
	#	elif movement_direction.down:
	#		set_animation("move_down")
	pass


func set_animation(animation):
	if current_animation != animation:
		for sprite in get_children():
			sprite.play(animation)
			sprite.set_frame_and_progress(1,0)
			current_animation = animation


