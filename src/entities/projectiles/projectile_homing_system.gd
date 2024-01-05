class_name ProjectileHomingSystem
extends Node

var _ProjectileMovementComponent: ProjectileMovementComponent = null
@onready var parent = get_parent().get_parent()

var max_distance = 200

func _ready():
	if _ProjectileMovementComponent == null:
		var comp_arr = GameManager.get_entity_component(parent, ProjectileMovementComponent)
		if comp_arr:
			_ProjectileMovementComponent = comp_arr[0]
			_ProjectileMovementComponent.before_motion.connect(redirect)
		else:
			set_physics_process(false)

func redirect():
	var destination = parent.position + parent.launch_direction
	parent = parent as BaseProjectile
	if not parent.is_friendly:
		destination = GameManager.player.position
	else:
		var enemy = EnemiesHandler.get_enemy_closest_to(parent, parent.already_hit)
		if enemy != null and is_instance_valid(enemy):
			var target_destination = enemy.global_position
			if (target_destination - parent.global_position).length() < max_distance:
				destination = target_destination
	
	_ProjectileMovementComponent.direction = (destination - parent.global_position).normalized()
	
