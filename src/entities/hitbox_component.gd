class_name HitboxComponent
extends Area2D

func get_entity():
	return get_parent().get_parent()
