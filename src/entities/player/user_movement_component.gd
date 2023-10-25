class_name UserMovementComponent
extends Node

var speed := 500.0
var _velocity := Vector2.ZERO

@onready var parent: CharacterBody2D = get_parent().get_parent()

var is_idle := true

var current_animation = ""
var animation = ""

@export var _HitboxComponent: HitboxComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent

var direction_held = {
	left=false,
	right=false,
	down=false,
	up=false,
}

var movement_direction = {
	left=true,
	right=false,
	down=false,
	up=false,
}


func _input(event):
	if event is InputEventKey && !event.echo:
		if event.is_action("move_left"):
			direction_held.left = event.pressed
		elif event.is_action("move_right"):
			direction_held.right = event.pressed
		elif event.is_action("move_down"):
			direction_held.down = event.pressed
		elif event.is_action("move_up"):
			direction_held.up = event.pressed


func _physics_process(delta):
	_velocity.x = speed* - int(direction_held.left) + speed*int(direction_held.right)
	_velocity.y = speed* - int(direction_held.up) + speed*int(direction_held.down)
	
	movement_direction.right = _velocity.x > 0
	movement_direction.left = _velocity.x < 0
	movement_direction.up = _velocity.y < 0
	movement_direction.down = _velocity.y > 0
	
	if _velocity == Vector2(0,0):
		is_idle = true
	else: is_idle = false
	
	parent.velocity = _velocity
	
	var collision = parent.move_and_collide(parent.velocity * delta)
	if collision:
		parent.velocity = parent.velocity.slide(collision.get_normal())
		collision = parent.move_and_collide(parent.velocity * delta)

	
	if _AnimatedSpriteComponent:
		if is_idle:
			_AnimatedSpriteComponent.set_animation("idle")
		else:
			if movement_direction.left:
				_AnimatedSpriteComponent.set_animation("move_left")
			elif movement_direction.right:
				_AnimatedSpriteComponent.set_animation("move_right")
			elif movement_direction.up:
				_AnimatedSpriteComponent.set_animation("move_up")
			elif movement_direction.down:
				_AnimatedSpriteComponent.set_animation("move_down")
