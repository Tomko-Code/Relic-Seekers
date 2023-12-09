class_name BaseProjectile
extends CharacterBody2D

var type: String = "base_projectile"
var speed: float = 100.0
var range: float = 100
var effects: Array = []
var damage: int = 1
var can_bounce: bool = false

signal launched
signal expired
signal on_hit

@export var _ProjectileMovementComponent: ProjectileMovementComponent

func initialize(projectile_data: Dictionary):
	speed = projectile_data.get("speed", speed)
	range = projectile_data.get("range", range)
	effects = projectile_data.get("effects", effects)
	damage = projectile_data.get("damage", damage)
	can_bounce = projectile_data.get("can_bounce", can_bounce)

func launch(direction_vector: Vector2):
	_ProjectileMovementComponent.launch(direction_vector, speed, range)
	emit_signal("launched")

func expire():
	emit_signal("expired")
	queue_free()

func hit(target):
	emit_signal("on_hit")
	expire()
