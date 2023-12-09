class_name StatsComponent
extends Node


@onready var parent: CharacterBody2D = get_parent().get_parent()

@export var shoot_speed: float = 500
@export var shoot_range: float = 100
@export var shoot_damage: int = 1
@export var shoot_frequency: float = 1

@export var projectile_type: String

@export var max_health: float = 10
var current_health: float = max_health

func get_projectile_data():
	return {
		type = projectile_type,
		speed = shoot_speed,
		range = shoot_range,
		damage = shoot_damage,
		effects = get_shoot_effects()
	}

func get_projectile_type():
	return projectile_type
	
func get_shoot_speed():
	return shoot_speed

func get_shoot_range():
	return shoot_range

func get_shoot_effects():
	return []

func get_shoot_damage():
	return shoot_damage

func get_shoot_frequency():
	return shoot_frequency

func change_health(value):
	current_health -= value
	parent.emit_signal("health_changed")
	if current_health <= 0:
		parent.call_death()
