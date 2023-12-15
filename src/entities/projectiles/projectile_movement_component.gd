class_name ProjectileMovementComponent
extends MovementComponent

var velocity: Vector2
var distance_traveled_duration: float = 0
var range: float = 0
var can_bounce = false

func _ready():
	speed = parent.speed
	range = parent.range
	can_bounce = parent.can_bounce
	
	if not parent is BaseProjectile:
		push_error("ProjectileMovementComponent set on BaseProjectile")
	
	is_idle = false
	is_rotable = true
	set_physics_process(false)
	pass

func launch(_direction_vector = Vector2(1,1), _speed = 500, _range = 100):
	if not is_node_ready():
		await ready
	direction = _direction_vector
	speed = _speed
	range = _range
	set_physics_process(true)
	

func _physics_process(delta):
	distance_traveled_duration += delta
	if distance_traveled_duration > range / 60:
		parent.expire()
	velocity = direction.normalized() * speed
	
	var collision = parent.move_and_collide(velocity * delta)
	if collision and can_bounce:
		velocity = velocity.bounce(collision.get_normal())
		direction = direction.bounce(collision.get_normal())

		#velocity = velocity.slide(collision.get_normal())
		collision = parent.move_and_collide(velocity * delta)
	elif collision:
		parent.expire()
