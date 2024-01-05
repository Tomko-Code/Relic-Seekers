class_name ProjectileChainEffectSystem
extends Node

var parent: BaseProjectile = get_parent().get_parent()
var _ProjectileMovementComponent: ProjectileMovementComponent
var max_distance = 200

func _ready():
	if _ProjectileMovementComponent == null:
		var comp_arr = GameManager.get_entity_component(parent, ProjectileMovementComponent)
		if comp_arr:
			_ProjectileMovementComponent = comp_arr[0]
			await get_tree().process_frame
			parent.on_hit.connect(full_send_it)
		else:
			set_physics_process(false)

func full_send_it():
	while not parent.is_expired:
		
		redirect()
		
		var trail = ProjectileTrail.new()
		trail.frames = load("res://assets/sprites/other/trail/trail1.tres")
		trail.play("default")
		trail.rotation = _ProjectileMovementComponent.get_direction().angle()
		trail.position = parent.position
		if parent.trail_particles != null:
			trail.modulate = parent.trail_particles.color
		parent.get_parent().add_child.call_deferred(trail)
		
		_ProjectileMovementComponent._physics_process(16 / (_ProjectileMovementComponent.speed))

func redirect() -> bool:
	var destination = null
	parent = parent as BaseProjectile
	if not parent.is_friendly:
		destination = GameManager.player.position
	else:
		var enemy = EnemiesHandler.get_enemy_closest_to(parent, parent.already_hit)
		if enemy != null and is_instance_valid(enemy):
			var target_destination = enemy.global_position
			if (target_destination - parent.global_position).length() < max_distance:
				destination = target_destination
	if destination == null:
		return false
	else:
		_ProjectileMovementComponent.direction = (destination - parent.global_position).normalized()
		return true
