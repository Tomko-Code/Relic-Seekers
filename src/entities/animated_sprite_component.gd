class_name AnimatedSpriteComponent
extends Node2D

var current_animation = ""

func set_animation(animation, animation_direction = 1, force: bool = false):
	if current_animation != animation or force:
		for sprite in get_children():
			if sprite is AnimatedSprite2D and sprite.sprite_frames != null and sprite.sprite_frames.has_animation(animation):
				sprite = sprite as AnimatedSprite2D
				sprite.play(animation, animation_direction)
				sprite.set_frame_and_progress(1,0)
				current_animation = animation
			return true
	return false
