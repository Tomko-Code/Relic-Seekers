class_name UserMouseShootingComponent
extends ShootingComponent

@export var _PlayerStatsComponent: PlayerStatsComponent
@export var _MovementComponent: MovementComponent

signal on_shoot

func get_direction():
	return parent.get_local_mouse_position().normalized()

func shoot(direction_vector):
	var projectile: BaseProjectile = _PlayerStatsComponent.current_spell.spawn_projectile()
	if projectile == null:
		return
	#var projectile: FriendlyProjectile = load("res://src/entities/projectiles/friendly_projectile.tscn").instantiate()
	projectile.position = parent.position + get_direction() * 20
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
	emit_signal("on_shoot")

func _physics_process(delta):
	if parent.paused:
		return
		
	if is_shooting and GameData.save_file.player_inventory.get_current_spell().can_cast():
		shoot(get_direction())
