class_name UserMovementComponent
extends Node

var speed := 50000.0
var _direction := Vector2.ZERO

@onready var parent: CharacterBody2D = get_parent().get_parent()

var is_idle := true

var current_animation = ""
var animation = ""

@export var _HitboxComponent: HitboxComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent


func _physics_process(delta):
	_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		_direction.x += 1
	if Input.is_action_pressed("move_up"):
		_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		_direction.y += 1

	
	if _direction == Vector2.ZERO:
		is_idle = true
	else: is_idle = false
	
	parent.velocity = _direction.normalized() * delta * speed
	
	var collision = parent.move_and_collide(parent.velocity * delta)
	if collision:
		parent.velocity = parent.velocity.slide(collision.get_normal())
		collision = parent.move_and_collide(parent.velocity * delta)

	
	if _AnimatedSpriteComponent:
		if is_idle:
			_AnimatedSpriteComponent.set_animation("idle")
		else:
			if _direction.x < 0:
				_AnimatedSpriteComponent.set_animation("move_left")
			elif _direction.x > 0:
				_AnimatedSpriteComponent.set_animation("move_right")
			elif _direction.y < 0:
				_AnimatedSpriteComponent.set_animation("move_up")
			elif _direction.y > 0:
				_AnimatedSpriteComponent.set_animation("move_down")
