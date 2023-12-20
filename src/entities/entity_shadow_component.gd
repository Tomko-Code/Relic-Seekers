class_name EntityShadowComponent
extends Node2D

@export var _AnimatedSpriteComponent: AnimatedSpriteComponent
@export var height: float = 0

func _draw():
	var pos = Vector2.ZERO
	var x_val = 0.0
	for sprite in _AnimatedSpriteComponent.get_children():
		if sprite is AnimatedSprite2D:
			sprite as AnimatedSprite2D
			var frames = sprite.sprite_frames as SpriteFrames
			if frames == null:
				continue
			var texture = frames.get_frame_texture(sprite.animation, sprite.frame)
			var texture_size = texture.get_size() * sprite.scale
			if texture_size.y > pos.y:
				pos.y = texture_size.y
			if texture_size.x > x_val:
				x_val = texture_size.x
		elif sprite is Sprite2D:
			sprite as Sprite2D
			var texture = sprite.texture
			var texture_size = texture.get_size() * sprite.scale
			if texture_size.y > pos.y:
				pos.y = texture_size.y
			if texture_size.x > x_val:
				x_val = texture_size.x
	x_val /= 6
	pos.x = 0
	pos.y = (pos.y / 2) + height
	
	draw_set_transform(pos,0,x_val * Vector2(3,1) )
	draw_circle(Vector2(0,0),1.0,Color(0.0,0.0,0.0,0.3))

