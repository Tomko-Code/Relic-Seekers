class_name HitboxComponent
extends Area2D


@export var _StatsComponent: StatsComponent


func get_entity():
	return get_parent().get_parent()

#on projectile hit entity
func _on_bullet_hitbox_component_area_entered(_area):
	if _area is HitboxComponent:
		var hitbox: HitboxComponent = _area
		var entity = hitbox.get_entity()
		
		if _StatsComponent and entity is BaseProjectile:
			_StatsComponent.take_damage(entity.damage)
			
		if entity is BaseProjectile:
			entity.hit(get_entity())
