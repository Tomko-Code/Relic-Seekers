class_name MovementComponent
extends Node

var speed := 300.0
var direction := Vector2.ZERO

@onready var parent: CharacterBody2D = get_parent().get_parent()

var is_idle := true
var is_rotable := false

func get_direction():
	return direction

func recoil(entity: Node2D):
	if entity is BaseProjectile:
		parent.velocity += 100.0 * entity.damage * entity.launch_direction.normalized() / 2
	else:
		var recoil_direction = (parent.global_position - entity.global_position).normalized()
		parent.velocity += 100 * recoil_direction
