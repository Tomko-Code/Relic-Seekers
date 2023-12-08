class_name CombatSystem
extends Node


@export var _HitboxComponent: HitboxComponent
@export var _StatsComponent: StatsComponent
@export var _MovementComponent: MovementComponent


func _ready():
	_HitboxComponent.area_entered.connect(_on_bullet_enter_hitbox)

func get_entity():
	return get_parent().get_parent()

#on projectile hit entity
func _on_bullet_enter_hitbox(_area):
	if _MovementComponent is UserMovementComponent:
		_MovementComponent = _MovementComponent as UserMovementComponent
		if _MovementComponent.is_dashing:
			return
	if _area is HitboxComponent:
		var hitbox: HitboxComponent = _area
		var bullet = hitbox.get_entity()
		
		if _StatsComponent and bullet is BaseProjectile:
			_StatsComponent.change_health(bullet.damage)
			
		if bullet is BaseProjectile:
			bullet.hit(get_entity())
