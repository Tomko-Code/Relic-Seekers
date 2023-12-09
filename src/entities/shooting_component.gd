class_name ShootingComponent
extends Node

@onready var parent: CharacterBody2D = get_parent().get_parent()

var is_shooting = false


func get_direction():
	return Vector2.ZERO

func shoot(direction_vector):
	pass
