extends Node2D

enum STATES {
	NONE,
	FOLLOW,
	SHOOTING,
	SLAM,
	SLAM2
}

@export var animation_system: FourDirectionMovementSystemExtra

@export var animation: AnimatedSpriteComponent
@export var follow_behaviour: FollowEnemyBehaviour
@export var shooting_behaviour: ShootAtEnemyBehaviour
@export var shooting: ShootInDirectionComponent

@export var stats: StatsComponent

@export var clock: Timer
@export var extra_clock: Timer

var current_state: STATES = STATES.NONE
var shoot_speeds = [500,400,300]
@onready var default_shoot_speed = stats.get_shoot_speed()

var slam_direction = [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN,
(Vector2.UP + Vector2.LEFT).normalized(),
(Vector2.UP + Vector2.RIGHT).normalized(),
(Vector2.DOWN + Vector2.LEFT).normalized(),
(Vector2.DOWN + Vector2.RIGHT).normalized(),
]

func _ready():
	progress_state()
	clock.timeout.connect(progress_state)

func match_state(state: STATES):
	current_state = state
	match state:
		STATES.FOLLOW:
			follow_behaviour.active = true
			shooting_behaviour.active = false
			animation_system._ShootingComponent = null
			
			clock.start(1)
		STATES.SHOOTING:
			follow_behaviour.active = false
			shooting_behaviour.active = true
			animation_system._ShootingComponent = shooting
			
			stats.shoot_speed = default_shoot_speed
			
			clock.start(2)
		STATES.SLAM:
			animation_system._ShootingComponent = null
			follow_behaviour.active = false
			shooting_behaviour.active = false
			animation_system.set_process(false)
			
			animation.set_animation("slam")
			var sprite = animation.get_children()[0] as AnimatedSprite2D
			await sprite.animation_finished
			animation_system.set_process(true)
			slam()
			progress_state()
		STATES.SLAM2:
			animation_system._ShootingComponent = null
			follow_behaviour.active = false
			shooting_behaviour.active = false
			animation_system.set_process(false)
			
			for x in randi_range(2,3):
				print(animation.set_animation("slam", 1 , true))
				var sprite = animation.get_children()[0] as AnimatedSprite2D
				await sprite.animation_finished
				slam_type_2()
				#extra_clock.start()
				#await extra_clock.timeout
				print("TIMEOUT")
			
			animation_system.set_process(true)
			progress_state()

func slam():
	for speed in shoot_speeds:
		stats.shoot_speed = speed
		for direction in slam_direction:
			shooting.force_shoot(direction)
	var active_particles = load("res://assets/particles/slam_particles.tscn").instantiate() as CPUParticles2D
	active_particles.position = get_parent().position
	get_parent().call_deferred("add_child", active_particles)
	active_particles.run()

func slam_type_2():
	for val in range(64):
		shooting.force_shoot(Vector2.from_angle((PI*2) * (float(val) / float(64))))
	var active_particles = load("res://assets/particles/slam_particles.tscn").instantiate() as CPUParticles2D
	active_particles.position = get_parent().position
	get_parent().call_deferred("add_child", active_particles)
	active_particles.run()

func progress_state():
	match current_state:
		STATES.NONE:
			match_state(STATES.FOLLOW)
		STATES.FOLLOW:
			match_state(STATES.SLAM)
		STATES.SHOOTING:
			match_state(STATES.SLAM2)
		STATES.SLAM:
			match_state(STATES.SHOOTING)
		STATES.SLAM2:
			match_state(STATES.FOLLOW)
