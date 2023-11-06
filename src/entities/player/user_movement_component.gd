class_name UserMovementComponent
extends MovementComponent


func _physics_process(delta):
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1

	
	if direction == Vector2.ZERO:
		is_idle = true
	else: is_idle = false
	
	parent.velocity = direction.normalized() * delta * speed
	
	var collision = parent.move_and_collide(parent.velocity * delta)
	if collision:
		parent.velocity = parent.velocity.slide(collision.get_normal())
		collision = parent.move_and_collide(parent.velocity * delta)



