class_name MoveToDestMovementComponent
extends MovementComponent


@export var nav_agent: NavigationAgent2D
@onready var timer = Timer.new()
var destination = Vector2.ZERO
var is_moving = false

func _ready():
	destination = parent.global_position
	timer.autostart = true
	timer.wait_time = 0.1
	timer.timeout.connect(make_path)
	parent.call_deferred("add_child", timer)

func get_direction():
	return direction

func make_path():
	nav_agent.target_position = destination
	
func _physics_process(delta):
	if not is_moving:
		is_idle = true
		return
	
	var next_position = nav_agent.get_next_path_position()
	if (next_position - parent.global_position).length() < 1:
		direction = Vector2.ZERO
	else:
		direction = parent.to_local(next_position).normalized()
	
	if direction == Vector2.ZERO:
		is_idle = true
	else: is_idle = false

	parent.velocity = parent.velocity.lerp(direction.normalized() * speed, acceleration * delta)
	parent.move_and_slide()
