class_name HitboxComponent
extends Area2D

@export var entity: Node2D = null

func get_entity():
	if entity == null:
		return get_parent().get_parent()
	else:
		return entity
