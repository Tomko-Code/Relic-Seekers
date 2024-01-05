class_name ProjectileHomingSystem
extends Node

var _ProjectileMovementComponent: ProjectileMovementComponent = null
@onready var parent = get_parent().get_parent()

func _ready():
	if _ProjectileMovementComponent == null:
		_ProjectileMovementComponent = GameManager.get_entity_component(parent, ProjectileMovementComponent)[0]

func _physics_process(delta):
	var destination = parent.position + parent.launch_direction
	parent = parent as BaseProjectile
	if not parent.is_friendly:
		destination = GameManager.player.position
	else:
		var enemy = EnemiesHandler.get_enemy_closest_to(parent, parent.already_hit)
		if enemy != null and is_instance_valid(enemy):
			var target_destination = enemy.global_position
			if (target_destination - parent.global_position).length() < 200:
				destination = target_destination
	
	_ProjectileMovementComponent.direction = (destination - parent.global_position).normalized()
