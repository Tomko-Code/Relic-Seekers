class_name ShootAtEnemyBehaviour
extends Node

@onready var parent = get_parent().get_parent()
@export var shooting: ShootInDirectionComponent = null
var active = false

func _physics_process(delta):
	if active and shooting != null:
		shooting.shooting_direction = GameManager.player.global_position - parent.global_position
		shooting.is_shooting = true
	elif shooting != null:
		shooting.is_shooting = false
