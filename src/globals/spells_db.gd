extends Node


func _init():
	spells.default_spell = spells.fireball
	spells.default_spell.max_mana = -1
	
	spells.test_spell = spells.icicle

var spells = {
	default_spell = null,
	test_spell = null,
	fireball = {
		type= "default_spell",
		full_name = "Fireball",
		projectile_type = "fireball",
		description = "Create a ball of fire",
		projectile_data = {
			damage = 5,
			speed = 400,
			range = 100,
		},
		frames = load("res://assets/sprites/spells/fireball_spell.tres"),
		effects = [],
		max_mana = 100,
		shoot_frequency = 0.1,
	},
	spark = {
		type = "spark",
		full_name = "Spark",
		projectile_type = "spark",
		description = "Launch an electric spark",
		projectile_data = { 
			effects = [
				DeviateMovementDirection.new().init(deg_to_rad(30.0)),
				BounceEffect.new(),
			], 
			damage = 5,
			speed = 500,
			range = 100,
		},
		frames = load("res://assets/sprites/spells/spark_spell.tres"),
		effects = [
			SparkSpellEffect.new()
		],
		max_mana = 50,
		shoot_frequency = 0.5,
	},
	icicle = {
		type = "icicle",
		full_name = "Icicle",
		projectile_type = "icicle",
		description = "Launch ice projectile",
		projectile_data = { 
			effects = [
				PierceEffect.new(),
			], 
			damage = 8,
			speed = 700,
			range = 100,
		},
		frames = load("res://assets/sprites/spells/icicle_spell.tres"),
		effects = [],
		max_mana = 50,
		shoot_frequency = 0.5,
	}
}
