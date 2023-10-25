class_name PlayerEntity
extends CharacterBody2D

@onready var _UserMovementComponent = $UserMovementComponent
@onready var _AnimatedSpriteComponent = $AnimatedSpriteComponent
@onready var Camera = $Camera

var is_idle := true

func _ready():
	Camera.make_current()


func _physics_process(delta):
	if is_idle:
		_AnimatedSpriteComponent.set_animation("idle")
	else:
		if _UserMovementComponent.movement_direction.left:
			_AnimatedSpriteComponent.set_animation("move_left")
		elif _UserMovementComponent.movement_direction.right:
			_AnimatedSpriteComponent.set_animation("move_right")
		elif _UserMovementComponent.movement_direction.up:
			_AnimatedSpriteComponent.set_animation("move_up")
		elif _UserMovementComponent.movement_direction.down:
			_AnimatedSpriteComponent.set_animation("move_down")
