class_name ShootInDirectionComponent
extends ShootingComponent

#@onready var parent: CharacterBody2D = get_parent().get_parent()

@export var _StatsComponent: StatsComponent
@export var _MovementComponent: MovementComponent

var shooting_frequency_current = 0.0
@export var shooting_direction = Vector2.RIGHT

func get_direction():
	return shooting_direction

func shoot(direction_vector):
	var projectile = ProjectilesHandler.spawn_projectile(_StatsComponent.get_projectile_type(), false)
	if not projectile:
		push_error("FAILED TO SPAWN PROJECTILE")
	projectile.position = parent.position + (direction_vector.normalized()*32)
	
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
	if is_shooting and shooting_frequency_current == 0:
		shoot(get_direction())
	
	if is_shooting or shooting_frequency_current != 0:
		shooting_frequency_current += delta
	
	if shooting_frequency_current >= _StatsComponent.get_shoot_frequency():
		shooting_frequency_current = 0
	
