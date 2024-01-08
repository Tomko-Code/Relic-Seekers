class_name ExplosionArea
extends DamageArea

@export var shape: CollisionShape2D
var max_scale = 3.0
var current_scale = 1.0
var scaling_speed = 8.0

var core_color: Color = Color.WHITE
var despawn_particles: GenericParticles

var already_hit: Array = []

func _ready():
	despawn_particles = load("res://assets/particles/spawn_particles.tscn").instantiate()
	despawn_particles.color = Color.BLACK
	despawn_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	despawn_particles.set_emission_sphere_radius(16 * max_scale)
	despawn_particles.lifetime = 0.1
	update()

#func _draw():
#	draw_arc(Vector2.ZERO, 16, 0, 2*PI, 64, core_color, -1, true)

func from_projectile(projectile: BaseProjectile):
	if projectile.finish_particles:
		core_color = projectile.finish_particles.color
	damage = projectile.damage
	if not projectile.already_hit.is_empty():
		already_hit.append(projectile.already_hit.back())
	update()

func update():
	$Node2D/AnimatedSpriteComponent/Sprite2D.rotation = randf_range(0, 2*PI)
	$Node2D/AnimatedSpriteComponent/Sprite2D.modulate = core_color
	$CPUParticles2D.color = core_color
	#queue_redraw()

func _physics_process(delta):
	current_scale += delta * scaling_speed
	scale = Vector2(current_scale,current_scale)
	if current_scale >= max_scale:
		get_parent().call_deferred("add_child", despawn_particles)
		despawn_particles.run()
		despawn_particles.position = position
		queue_free()
		
