class_name UserMovementComponent
extends MovementComponent

var acceleration = 10
var is_dashing = false
var can_dash = true

var dash_max_cooldown = 0.5
var dash_current_cooldown = 0

var das_start_pos:Vector2

var dash_max_duration = 0.12
var dash_current_duration = 0
var last_direction

signal dash_over

@export var _AnimatedSpriteComponent: AnimatedSpriteComponent

func _ready():
	speed = 500

func _physics_process(delta):
	direction = Vector2.ZERO
	if parent.paused:
		return
	
	if not can_dash:
		dash_current_cooldown += delta
		if dash_current_cooldown >= dash_max_cooldown:
			dash_current_cooldown = 0
			can_dash = true
	
	if is_dashing:
		dash_current_duration += delta
		if dash_current_duration >= dash_max_duration:
			parent.velocity = Vector2.ZERO
			dash_current_duration = 0
			is_dashing = false
			emit_signal("dash_over")
		else:
			if _AnimatedSpriteComponent:
				var ghost = PlayerDashGhost.new()
				ghost.freeze_frame(_AnimatedSpriteComponent)
				ghost.position = parent.position
				parent.get_parent().call_deferred("add_child", ghost)
	
	if not is_dashing:
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
	else:
		direction = last_direction
	
	last_direction = direction
	
	if Input.is_action_pressed("dash") and direction != Vector2.ZERO and can_dash:
		# TODO : big kek but for now it's fine
		das_start_pos = $"../../PitHitBox/CollisionShape2D".global_position
		
		can_dash = false
		is_dashing = true
		
	
	if direction == Vector2.ZERO:
		is_idle = true
	else: is_idle = false
	
	#parent.velocity = direction.normalized() * delta * speed
	parent.velocity = parent.velocity.lerp(direction.normalized() * speed * (3 if is_dashing else 1), acceleration * delta * (10 if is_dashing else 1))
	
	parent.move_and_slide()
	#var collision = parent.move_and_collide(parent.velocity * delta)
	#if collision:
	#	parent.velocity = parent.velocity.slide(collision.get_normal())
	#	collision = parent.move_and_collide(parent.velocity * delta)

