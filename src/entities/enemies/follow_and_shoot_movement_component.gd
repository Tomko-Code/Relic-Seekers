class_name FollowAndShootMovementComponent
extends MovementComponent

@export var nav_agent: NavigationAgent2D
#@onready var nav_agent = NavigationAgent2D.new()
@onready var timer = Timer.new()

@export var _ShootingComponent: ShootingComponent

var acceleration = 10

func _ready():
	#parent.call_deferred("add_child", nav_agent)
	parent.call_deferred("add_child", timer)
	#nav_agent.set_navigation_layer_value(1,1)
	#nav_agent.set_avoidance_layer_value(2,1)
	await timer.ready
	timer.start(0.5)
	timer.timeout.connect(make_path)

func get_direction():
	return direction

func make_path():
	if _ShootingComponent.is_shooting and false:
		nav_agent.target_position = parent.position
	else:
		nav_agent.target_position = GameManager.player.global_position
	

func _physics_process(delta):
	direction = Vector2.ZERO
	direction = parent.to_local(nav_agent.get_next_path_position()).normalized()
	
	
	if direction == Vector2.ZERO:
		is_idle = true
	else: is_idle = false

	parent.velocity = parent.velocity.lerp(direction.normalized() * speed, acceleration * delta)
	parent.move_and_slide()
