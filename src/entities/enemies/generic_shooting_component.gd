class_name GenericShootingComponent
extends ShootingComponent

#@onready var parent: CharacterBody2D = get_parent().get_parent()

@export var _StatsComponent: StatsComponent
@export var _MovementComponent: MovementComponent

var shooting_frequency_current = 0.0


func get_direction():
	return GameManager.player.global_position - parent.global_position

func shoot(direction_vector):
	var projectile = ProjectilesHandler.spawn_projectile(_StatsComponent.get_projectile_type(), false)
	if not projectile:
		push_error("FAILED TO SPAWN PROJECTILE")
	projectile.position = parent.position
	
	projectile.initialize(_StatsComponent.get_projectile_data())
	
	parent.get_parent().call_deferred("add_child", projectile)
	
	if _MovementComponent and _MovementComponent.direction != Vector2.ZERO:
		var projectile_vector = direction_vector.normalized() * projectile.speed
		var movement_vector = _MovementComponent.direction.normalized() * (_MovementComponent.speed / 1000)
		
		var result_vector = projectile_vector + movement_vector
		projectile.speed = result_vector.length()
		projectile.launch(result_vector.normalized())
	else:
		projectile.launch(direction_vector)


func _physics_process(delta):
	var player = GameManager.player
	if not player:
		return
		
	var space_rid = parent.get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	
	
	var query = PhysicsRayQueryParameters2D.create(parent.global_position, player.global_position)
	query.collision_mask = 2
	var result = space_state.intersect_ray(query)
	
	if result:
		is_shooting = false
	else:
		is_shooting = true
	
	if is_shooting and shooting_frequency_current == 0:
		shoot(get_direction())
	
	if is_shooting or shooting_frequency_current != 0:
		shooting_frequency_current += delta
	
	if shooting_frequency_current >= _StatsComponent.get_shoot_frequency():
		shooting_frequency_current = 0
	
