class_name HomingProjectileMovementComponent
extends ProjectileMovementComponent

func _physics_process(delta):
	distance_traveled_duration += delta
	
	if _EntityShadowComponent:
		_EntityShadowComponent.height = 9 - (10 * (distance_traveled_duration/(range/60)))
		_EntityShadowComponent.queue_redraw()
	
	if distance_traveled_duration > range / 60:
		parent.expire()
	
	var destination = parent.position + parent.launch_direction
	parent = parent as BaseProjectile
	if not parent.is_friendly:
		destination = GameManager.player.position
	else:
		var enemy = EnemiesHandler.get_enemy_closest_to(parent)
		if enemy != null and is_instance_valid(enemy):
			var target_destination = enemy.global_position
			if (target_destination - parent.global_position).length() < 200:
				destination = target_destination
	
	direction = (destination - parent.global_position).normalized()
	velocity = direction.normalized() * speed
	
	var collision = parent.move_and_collide(velocity * delta)
	if collision and can_bounce:
		velocity = velocity.bounce(collision.get_normal())
		direction = direction.bounce(collision.get_normal())

		#velocity = velocity.slide(collision.get_normal())
		collision = parent.move_and_collide(velocity * delta)
	elif collision:
		parent.expire()
