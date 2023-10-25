class_name ProjectileMovementComponent
extends Node

@export var _AnimatedSpriteComponent: AnimatedSpriteComponent
@onready var parent: StaticBody2D = get_parent().get_parent()


var velocity: Vector2
var direction_vector: Vector2
var speed := 500


func _ready():
	set_physics_process(false)

func launch(_direction_vector = Vector2(1,1), _speed = 500):
	direction_vector = _direction_vector
	speed = _speed
	set_physics_process(true)


func _physics_process(delta):
	velocity = direction_vector.normalized() * speed
	
	var collision = parent.move_and_collide(get_parent().velocity * delta)
	if collision:
		get_parent().velocity = get_parent().velocity.slide(collision.get_normal())
		collision = get_parent().move_and_collide(get_parent().velocity * delta)

	
	if _AnimatedSpriteComponent:
		_AnimatedSpriteComponent.set_animation("bullet")
			
