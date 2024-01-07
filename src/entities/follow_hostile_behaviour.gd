class_name FollowEnemyBehaviour
extends Node

@export var movement: MoveToDestMovementComponent = null
var active = false

func _physics_process(delta):
	if active and movement != null:
		movement.destination = GameManager.player.global_position
		movement.is_moving = true
	elif  movement != null: # TODO RECONSIDER
		movement.is_moving = false
