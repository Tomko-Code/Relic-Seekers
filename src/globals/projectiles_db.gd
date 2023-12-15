extends Node

var projectiles: Dictionary = {
	test_projectile_a = {
		sprite = load("res://assets/sprites/projectiles/test_projectile_a.tres")
	},
	test_projectile_b = {
		sprite = load("res://assets/sprites/projectiles/test_projectile_b.tres")
	},
	fireball = {
		sprite = load("res://assets/sprites/projectiles/fireball_sprite.tres")
	},
	firefly = {
		sprite = load("res://assets/sprites/projectiles/fireball_sprite.tres"),
		speed = 100,
		range = 100,
		effects = [],
		damage = 7.0,
		can_bounce = false,
	},
}
