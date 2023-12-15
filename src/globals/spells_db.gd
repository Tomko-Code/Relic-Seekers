extends Node


func _init():
	spells.default_spell = spells.fireball
	spells.default_spell.max_mana = -1
	
	spells.test_spell = spells.spark

var spells = {
	default_spell = null,
	test_spell = null,
	fireball = {
		type= "default_spell",
		full_name = "Fireball",
		projectile_type = "fireball",
		description = "Create a ball of fire",
		projectile_data = {
			damage = 5
		},
		frames = load("res://assets/sprites/spells/fireball_spell.tres"),
		effects = [],
		max_mana = 100,
		ammo = -1,
		shoot_frequency = 0.5,
	},
	spark = {
		type = "spark",
		full_name = "Spark",
		projectile_type = "spark",
		description = "Launch an electric spark",
		projectile_data = { 
			can_bounce = true, 
			effects = [
				DeviateMovementDirection.new().init(deg_to_rad(30.0))
			], 
			damage = 5, 
		},
		frames = load("res://assets/sprites/spells/spark_spell.tres"),
		effects = [
			SparkSpellEffect.new()
		],
		max_mana = 100,
		ammo = 50,
		shoot_frequency = 0.5,
	}
}
