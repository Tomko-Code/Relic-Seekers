class_name UserShootingComponent
extends ShootingComponent

var last_direction = Vector2.ZERO

func _input(event):
	if event is InputEventKey && !event.echo:
		if event.is_action_pressed("shoot_left"):
			shoot(Vector2(-1, 0))
		elif event.is_action_pressed("shoot_right"):
			shoot(Vector2(1, 0))
		elif event.is_action_pressed("shoot_down"):
			shoot(Vector2(0, 1))
		elif event.is_action_pressed("shoot_up"):
			shoot(Vector2(0, -1))


func get_direction():
	return last_direction


func shoot(direction_vector):
	last_direction = direction_vector
	var projectile: FriendlyProjectile = load("res://src/entities/projectiles/friendly_projectile.tscn").instantiate()
	
	projectile.position = parent.position
	
	parent.get_parent().call_deferred("add_child", projectile)
	
	projectile.launch(direction_vector, 500)
	
