class_name MovementComponent
extends Node

var speed := 300.0
var direction := Vector2.ZERO

@onready var parent: CharacterBody2D = get_parent().get_parent()

var is_idle := true
var is_rotable := false

func get_direction() -> Vector2:
	return direction

func recoil(entity: Node2D):
	if entity is BaseProjectile:
		parent.velocity += 100.0 * entity.damage * entity.launch_direction.normalized() / 2
	else:
		var recoil_direction = (parent.global_position - entity.global_position).normalized()
		parent.velocity += 200 * recoil_direction

func _physics_process(delta):
	parent.velocity = parent.velocity.lerp(Vector2.ZERO.normalized() * speed, 10 * delta)
	parent.move_and_slide()
