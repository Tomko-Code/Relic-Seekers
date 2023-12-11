class_name BaseProjectile
extends CharacterBody2D

var type: String = "base_projectile"
var speed: float = 100.0
var range: float = 100
var effects: Array = []
var damage: float = 1
var can_bounce: bool = false

var is_friendly: bool = false
var launch_direction: Vector2 = Vector2.ZERO

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
	re_apply_effects()

func re_apply_effects():
	for effect in effects:
		effect = effect as SpellEffect
		effect.apply_on_projectile(self)

func launch(direction_vector: Vector2):
	launch_direction = direction_vector
	emit_signal("launched")
	_ProjectileMovementComponent.launch(direction_vector, speed, range)

func expire():
	emit_signal("expired")
	queue_free()

func hit(target):
	emit_signal("on_hit")
	expire()
