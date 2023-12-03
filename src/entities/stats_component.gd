class_name StatsComponent
extends Node


@onready var parent: CharacterBody2D = get_parent().get_parent()


func get_shoot_speed():
	return 500

func get_shoot_range():
	return 100

func get_shoot_effects():
	return []

func get_shoot_damage():
	return 1

func change_health(calue: int):
	parent.queue_free()
