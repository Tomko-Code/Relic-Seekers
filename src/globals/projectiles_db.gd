extends Node

var projectiles: Dictionary = {
	test_projectile_a = {
		sprite = load("res://assets/sprites/projectiles/test_projectile_a.tres")
	},
	test_projectile_b = {
		sprite = load("res://assets/sprites/projectiles/test_projectile_b.tres")
	},
	fireball = {
		sprite = load("res://assets/sprites/projectiles/fireball_sprite.tres"),
		spawn_particles = Color.ORANGE_RED,
		finish_particles = Color.ORANGE_RED,
		trail_particles = Color.ORANGE_RED,
	},
	spark = {
		sprite = load("res://assets/sprites/projectiles/spark_sprite.tres"),
		spawn_particles = Color.DEEP_SKY_BLUE,
		finish_particles = Color.DEEP_SKY_BLUE,
		trail_particles = Color.DEEP_SKY_BLUE,
	},
	firefly = {
		sprite = load("res://assets/sprites/projectiles/fireball_sprite.tres"),
		speed = 100,
		range = 100,
		effects = [],
		damage = 7.0,
	},
	icicle = {
		sprite = load("res://assets/sprites/projectiles/icicle_sprite.tres"),
		spawn_particles = Color.DARK_BLUE,
		finish_particles = Color.DARK_BLUE,
		trail_particles = Color.DARK_BLUE,
	},
	heal = {
		sprite = load("res://assets/sprites/projectiles/heal_sprite.tres"),
		spawn_particles = Color.DARK_GREEN,
		finish_particles = Color.DARK_GREEN,
		trail_particles = Color.DARK_GREEN,
	},
	hostile_projectile = {
		sprite = load("res://assets/sprites/projectiles/hostile_projectile_sprite.tres"),
		spawn_particles = Color.DIM_GRAY,
		finish_particles = Color.DIM_GRAY,
		trail_particles = Color.DIM_GRAY,
	},
	
}
