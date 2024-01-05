class_name ProjectileInstantMotionSystem
extends Node

var _ProjectileMovementComponent: ProjectileMovementComponent = null
@onready var parent: BaseProjectile = get_parent().get_parent()

func _ready():
	if _ProjectileMovementComponent == null:
		var comp_arr = GameManager.get_entity_component(parent, ProjectileMovementComponent)
		if comp_arr:
			_ProjectileMovementComponent = comp_arr[0]
			await get_tree().process_frame
			full_send_it()
		else:
			set_physics_process(false)
			
func full_send_it():
	while not parent.is_expired:
		print(get_physics_process_delta_time())
		var trail = ProjectileTrail.new()
		trail.frames = load("res://assets/sprites/other/trail/trail1.tres")
		trail.play("default")
		trail.rotation = _ProjectileMovementComponent.get_direction().angle()
		trail.position = parent.position
		if parent.trail_particles != null:
			trail.modulate = parent.trail_particles.color
		parent.get_parent().add_child.call_deferred(trail)
		
		_ProjectileMovementComponent._physics_process(get_physics_process_delta_time() * 2)
