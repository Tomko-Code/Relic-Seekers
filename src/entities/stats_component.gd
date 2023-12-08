class_name StatsComponent
extends Node


@onready var parent: CharacterBody2D = get_parent().get_parent()

@export var shoot_speed: float = 500
@export var shoot_range: float = 100
@export var shoot_damage = 1
@export var soot_frequency: float = 1

@export var projectile_type: String


func get_shoot_speed():
	return shoot_speed

func get_shoot_range():
	return shoot_range

func get_shoot_effects():
	return []

func get_shoot_damage():
	return shoot_damage

func get_shoot_frequency():
	return soot_frequency

func change_health(calue: int):
	parent.queue_free()
