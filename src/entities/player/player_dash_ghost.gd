class_name PlayerDashGhost
extends AnimatedSprite2D

func freeze_frame(sprite_component: AnimatedSpriteComponent):
	var animated_sprite: AnimatedSprite2D = sprite_component.get_child(0)
	var frames = animated_sprite.sprite_frames
	
	modulate = Color.SKY_BLUE
	sprite_frames = frames.duplicate()
	
	animation = animated_sprite.animation
	set_frame_and_progress(animated_sprite.frame, 0)


func _ready():
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.1)
	tween.tween_callback(queue_free)
	
