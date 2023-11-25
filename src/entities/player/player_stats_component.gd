class_name PlayerStatsComponent
extends StatsComponent

var max_health: int = 10
var current_health: int = max_health

var shoot_speed: float = 500
var shoot_range: float = 50
var shoot_damage: int = 10

func get_shoot_speed():
	return shoot_speed

func get_shoot_range():
	return shoot_range

func get_shoot_damage():
	return shoot_damage

func get_shoot_effects():
	return []
	
func get_health():
	return current_health

func take_damage(damage: int):
	current_health -= damage
	if current_health <= 0:
		parent.death()
