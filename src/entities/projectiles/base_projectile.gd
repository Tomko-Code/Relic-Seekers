class_name BaseProjectile
extends CharacterBody2D

var speed
var range
var effects
var damage

signal launched
signal expired
signal on_hit

@export var _ProjectileMovementComponent: ProjectileMovementComponent

func initialize(_speed: float, _range: float, _damage: float, _effects: Array):
	speed = _speed
	range = _range
	effects = _effects
	damage = _damage

func launch(direction_vector: Vector2):
	_ProjectileMovementComponent.launch(direction_vector, speed, range)
	emit_signal("launched")

func expire():
	emit_signal("expired")
	queue_free()

func hit(target):
	emit_signal("on_hit")
	queue_free()
