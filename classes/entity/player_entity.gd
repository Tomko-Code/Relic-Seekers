class_name PlayerEntity
extends Entity

var speed := 500.0
var _velocity := Vector2.ZERO

var is_idle := true

var current_animation = ""
var animation = ""

@onready var CompositeSprite = $CompositeSprite
@onready var Camera = $Camera

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


func _ready():
	Camera.make_current()


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
	
	if velocity.x != 0:
		movement_direction.right = _velocity.x > 0
		movement_direction.left = _velocity.x < 0
	if velocity.y != 0:
		movement_direction.up = _velocity.y < 0
		movement_direction.down = _velocity.y > 0
	
	velocity = _velocity
	
	
	if velocity == Vector2(0,0):
		is_idle = true
	else: is_idle = false
	#var collision = body.move_and_collide(velocity)
	#if collision:
	#	velocity = velocity.slide(collision.normal)
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
		move_and_collide(velocity * delta)
	
	
	if is_idle:
		print("idle")
		set_animation("idle")
	else:
		if movement_direction.left:
			set_animation("move_left")
		elif movement_direction.right:
			set_animation("move_right")
		elif movement_direction.up:
			set_animation("move_up")
		elif movement_direction.down:
			set_animation("move_down")
		print("Else")


#func _process(delta):
#	pass


func set_animation(animation):
	if current_animation != animation:
		for sprite in CompositeSprite.get_children():
			sprite.play(animation)
			sprite.set_frame_and_progress(1,0)
			current_animation = animation


