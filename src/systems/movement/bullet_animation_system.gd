class_name BulletAnimationSystem
extends Node

#required
@export var _MovementComponent: MovementComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent


func _process(delta):
	if _MovementComponent.is_idle:
		_AnimatedSpriteComponent.set_animation("idle")
	if _MovementComponent.is_rotable:
		_AnimatedSpriteComponent.rotation = _MovementComponent.get_direction().angle()
