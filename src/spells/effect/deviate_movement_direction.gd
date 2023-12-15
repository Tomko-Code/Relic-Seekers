class_name DeviateMovementDirection
extends ProjectileSpellEffect

@export var deviation: float

func init(value: float):
	deviation = value
	return self

func apply_on_projectile(projectile: BaseProjectile):
	projectile.launched.connect(attach_deviation.bind(projectile))

func attach_deviation(projectile: BaseProjectile):
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.autostart = true
	timer.timeout.connect(deviate_projectile.bind(projectile, timer))
	projectile.call_deferred("add_child", timer)
	
func deviate_projectile(projectile: BaseProjectile, timer: Timer):
	var movement_component = GameManager.get_entity_component(projectile, ProjectileMovementComponent)
	if movement_component:
		movement_component = movement_component[0] as ProjectileMovementComponent
		var original_angle = movement_component.get_direction().normalized().angle()
		var new_angle = original_angle + randf_range(-deviation/2, deviation/2)
		movement_component.direction = Vector2.from_angle(new_angle).normalized()
	else:
		timer.queue_free()

func get_description():
	return "Projectiles deviate from their path by %.0f degrees" % rad_to_deg(deviation)
