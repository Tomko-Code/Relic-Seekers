class_name Enemy
extends CharacterBody2D


func _on_bullet_hitbox_component_area_entered(_area):
	if _area is HitboxComponent:
		var hitbox: HitboxComponent = _area
		var entity = hitbox.get_entity()
		
		entity.queue_free()
		queue_free()
