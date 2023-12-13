class_name PickupAnimationSystem
extends Node

@export var is_floating: bool = false
@export var floating_height: float = 10.0
@export var floating_speed: float = 2.0

var float_tween: Tween

@export var _AnimatedSpriteComponent: AnimatedSpriteComponent

func _ready():
	if _AnimatedSpriteComponent:
		_AnimatedSpriteComponent.set_animation("default")
		if is_floating:
			animate_float()
	
func animate_float():
	if float_tween:
		float_tween.kill() # Abort the previous animation.
	
	var tweens = []
	
	for sprite in _AnimatedSpriteComponent.get_children():
		float_tween = create_tween()
		float_tween.tween_property(sprite, "position", Vector2(0, -floating_height), floating_speed/2).from(Vector2.ZERO)
		float_tween.tween_property(sprite, "position", Vector2(0, 0), floating_speed/2).from(Vector2(0, -floating_height))
		tweens.append(float_tween)
	
	float_tween.tween_callback(animate_float)
	for tween in tweens:
		tween.play()
	
	
