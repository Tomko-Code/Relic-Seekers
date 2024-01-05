class_name ProjectileTrail
extends AnimatedSprite2D

func set_frames(_frames: SpriteFrames):
	var frames = _frames
	play("default")

func _ready():
	var tween = create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(queue_free)
