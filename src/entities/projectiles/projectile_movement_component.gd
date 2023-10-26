class_name ProjectileMovementComponent
extends Node

@export var _AnimatedSpriteComponent: AnimatedSpriteComponent
@onready var parent = get_parent().get_parent()


var velocity: Vector2
var direction_vector: Vector2
var speed := 500


func _ready():
	set_physics_process(false)
	pass

func launch(_direction_vector = Vector2(1,1), _speed = 500):
	if not is_node_ready():
		await ready
	direction_vector = _direction_vector
	speed = _speed
	set_physics_process(true)
	

func _physics_process(delta):
	velocity = direction_vector.normalized() * speed
	
	var collision = parent.move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
		collision = parent.move_and_collide(velocity * delta)

	
	if _AnimatedSpriteComponent:
		_AnimatedSpriteComponent.set_animation("default")
			
