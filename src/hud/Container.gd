extends PanelContainer

func _ready():
	var a = $AnimatedSprite2D.sprite_frames as SpriteFrames
	size = a.get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.frame).get_size() + (Vector2(4,4)*2)
