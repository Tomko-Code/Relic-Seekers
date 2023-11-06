class_name UserMouseShootingComponent
extends ShootingComponent


func _input(event):
	if event is InputEventMouse:
		if event.is_action_pressed("shoot_left_click"):
			shoot(get_direction())
			

func get_direction():
	return parent.get_local_mouse_position().normalized()


func shoot(direction_vector):
	var projectile: FriendlyProjectile = load("res://src/entities/projectiles/friendly_projectile.tscn").instantiate()
	projectile.position = parent.position
	parent.get_parent().call_deferred("add_child", projectile)
	projectile.launch(direction_vector, 500)
