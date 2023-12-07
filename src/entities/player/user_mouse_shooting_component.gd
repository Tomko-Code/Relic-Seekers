class_name UserMouseShootingComponent
extends ShootingComponent

@export var _StatsComponent: StatsComponent
@export var _MovementComponent: MovementComponent

func _input(event):
	if parent.paused:
		return
	
	if event is InputEventMouse:
		if event.is_action_pressed("shoot_left_click"):
			shoot(get_direction())
			

func get_direction():
	return parent.get_local_mouse_position().normalized()


func shoot(direction_vector):
	var projectile = ProjectilesHandler.spawn_projectile("test_projectile_b", true)
	if not projectile:
		push_error("FAILED TO SPAWN PROJECTILE")
	#var projectile: FriendlyProjectile = load("res://src/entities/projectiles/friendly_projectile.tscn").instantiate()
	projectile.position = parent.position
	
	projectile.initialize(_StatsComponent.get_shoot_speed(), 
		_StatsComponent.get_shoot_range(),
		_StatsComponent.get_shoot_damage(),
		_StatsComponent.get_shoot_effects())
	
	parent.get_parent().call_deferred("add_child", projectile)
	#parent.get_parent().add_child(projectile)
	
	if _MovementComponent and _MovementComponent.direction != Vector2.ZERO:
		var projectile_vector = direction_vector.normalized() * projectile.speed
		var movement_vector = _MovementComponent.direction.normalized() * (_MovementComponent.speed / 1000)
		
		var result_vector = projectile_vector + movement_vector
		projectile.speed = result_vector.length()
		projectile.launch(result_vector.normalized())
	else:
		projectile.launch(direction_vector)
