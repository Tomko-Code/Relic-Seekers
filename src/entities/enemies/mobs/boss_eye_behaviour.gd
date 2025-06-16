extends Node2D

enum STATES {
	NONE,
	FOLLOW,
	SHOOTING,
	SHOOTING_RANDOM,
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
@export var random_shooting_clock: Timer

var current_state: STATES = STATES.NONE
var shoot_speeds = [500,400,300]
@onready var default_shoot_speed = stats.get_shoot_speed()

var slam_direction = [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN,
(Vector2.UP + Vector2.LEFT).normalized(),
(Vector2.UP + Vector2.RIGHT).normalized(),
(Vector2.DOWN + Vector2.LEFT).normalized(),
(Vector2.DOWN + Vector2.RIGHT).normalized(),
]

var current_spawn_treshold:float
var health_division:float = 10

func _ready():
	progress_state()
	clock.timeout.connect(progress_state)
	current_spawn_treshold = stats.max_health
	intcrement_spawn_treshold()

func _process(delta: float) -> void:
	if current_spawn_treshold >= stats.current_health and current_spawn_treshold > 0:
		intcrement_spawn_treshold()
		var game: Game = GameManager.loaded_scenes["Game"]
		game.current_level.currnet_active_room.spawn_enemy("stone_eye_purple")

func intcrement_spawn_treshold() -> void:
	var chunks:float = (8.0*GameData.save_file.cores_placed)+8.0
	current_spawn_treshold = current_spawn_treshold - (stats.max_health/chunks)

func match_state(state: STATES):
	current_state = state
	match state:
		STATES.FOLLOW:
			follow_behaviour.active = true
			shooting_behaviour.active = false
			animation_system._ShootingComponent = null
			
			clock.start(1)
		STATES.SHOOTING:
			stats.projectile_type = "hostile_projectile_2"
			follow_behaviour.active = false
			shooting_behaviour.active = true
			animation_system._ShootingComponent = shooting
			
			stats.shoot_speed = default_shoot_speed
			
			clock.start(2)
		STATES.SHOOTING_RANDOM:
			stats.projectile_type = "hostile_projectile"
			animation_system._ShootingComponent = null
			follow_behaviour.active = false
			shooting_behaviour.active = false
			animation_system.set_process(false)
			stats.shoot_speed = 150
			
			random_shooting_clock.start()
			
			clock.start(6)
			
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
				print("golem:TIMEOUT")
			
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
	random_shooting_clock.stop()
	
	match current_state:
		STATES.NONE:
			match_state(STATES.FOLLOW)
		STATES.FOLLOW:
			match_state(STATES.SHOOTING)
		STATES.SHOOTING:
			match_state(STATES.SHOOTING_RANDOM)
		STATES.SHOOTING_RANDOM:
			match_state(STATES.FOLLOW)
		#STATES.SLAM:
			#match_state(STATES.SHOOTING)
		#STATES.SLAM2:
			#match_state(STATES.FOLLOW)


func _on_radnom_shooting_timeout() -> void:
	for x in range(4):
		stats.projectile_type = "hostile_projectile"
		shooting.force_shoot(Vector2(randf_range(-1,1),randf_range(-1,1)).normalized())
