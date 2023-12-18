class_name BaseProjectile
extends CharacterBody2D

var type: String = "base_projectile"
var speed: float = 100.0
var range: float = 100
var effects: Array = []
var damage: float = 1
var can_bounce: bool = false

var is_piercing: bool = false

var was_launched: bool = false
var already_hit: Array = []

var is_friendly: bool = false
var launch_direction: Vector2 = Vector2.ZERO

var spawn_particles: CPUParticles2D = null
var finish_particles: CPUParticles2D = null
var trail_particles: CPUParticles2D = null

signal launched
signal expired
signal on_hit

var projectile_data: Dictionary

@export var _ProjectileMovementComponent: ProjectileMovementComponent

func get_projectile_data():
	if projectile_data:
		return projectile_data
	else:
		return {
			speed = speed,
			range = range,
			effects = effects,
			damage = damage,
			can_bounce = can_bounce,
		}

func initialize(_projectile_data: Dictionary):
	projectile_data = _projectile_data
	speed = projectile_data.get("speed", speed)
	range = projectile_data.get("range", range)
	effects = projectile_data.get("effects", effects)
	damage = projectile_data.get("damage", damage)
	can_bounce = projectile_data.get("can_bounce", can_bounce)
	
	if projectile_data.has("spawn_particles"):
		if projectile_data.spawn_particles is Color:
			spawn_particles = load("res://assets/particles/spawn_particles.tscn").instantiate()
			spawn_particles.color = projectile_data.spawn_particles
	
	if projectile_data.has("finish_particles"):
		if projectile_data.finish_particles is Color:
			finish_particles = load("res://assets/particles/explosion_particles.tscn").instantiate()
			finish_particles.color = projectile_data.finish_particles
		
	if projectile_data.has("trail_particles"):
		if projectile_data.trail_particles is Color:
			trail_particles = load("res://assets/particles/trail_particles.tscn").instantiate()
			trail_particles.color = projectile_data.trail_particles
		var trail_timer = Timer.new()
		trail_timer.timeout.connect(update_trail_direction)
		add_child(trail_timer)
		add_child(trail_particles)
		trail_timer.wait_time = 0.1
		trail_timer.autostart = true
	re_apply_effects()

func re_apply_effects():
	for effect in effects:
		effect = effect as SpellEffect
		effect.apply_on_projectile(self)

func launch(direction_vector: Vector2):
	#if not was_launched:
	#	SoundManager.play_sfx("spawn_sound")
	launch_direction = direction_vector
	emit_signal("launched")
	if _ProjectileMovementComponent:
		_ProjectileMovementComponent.launch(direction_vector, speed, range)
	if not is_node_ready():
		await ready
		if spawn_particles != null and not was_launched:
			spawn_particles.position = position
			get_parent().call_deferred("add_child", spawn_particles)
			spawn_particles.run()
	was_launched = true
	

func update_trail_direction():
	if _ProjectileMovementComponent:
		trail_particles.direction = -_ProjectileMovementComponent.get_direction().normalized()

var is_expired = false
func expire():
	if is_expired:
		return
	is_expired = true
	emit_signal("expired")
	if finish_particles != null:
		finish_particles.position = position
		get_parent().call_deferred("add_child", finish_particles)
		finish_particles.run()
	queue_free()

func hit(target):
	SoundManager.play_sfx("hit_sfx")
	emit_signal("on_hit")
	if not is_piercing:
		expire()
	else:
		already_hit.append(target)
