class_name ProjectileMovementComponent
extends MovementComponent

var velocity: Vector2


func _ready():
	is_idle = false
	is_rotable = true
	set_physics_process(false)
	pass

func launch(_direction_vector = Vector2(1,1), _speed = 500):
	if not is_node_ready():
		await ready
	direction = _direction_vector
	speed = _speed
	set_physics_process(true)
	

func _physics_process(delta):
	velocity = direction.normalized() * speed
	
	var collision = parent.move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
		collision = parent.move_and_collide(velocity * delta)
			
