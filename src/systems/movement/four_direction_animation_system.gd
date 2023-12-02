class_name FourDirectionAnimationSystem
extends Node

#required
@export var _MovementComponent: MovementComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent


func _process(delta):
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
