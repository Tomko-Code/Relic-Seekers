extends Node


func _init():
	spells.default_spell = spells.fireball.duplicate(true)
	spells.default_spell.max_mana = -1
	
	spells.test_spell = spells.heal

var random_pool = [
	["fireball", 2],
	["icicle", 3],
	["heal", 1],
	["spark", 3],
]

var spells = {
	default_spell = null,
	test_spell = null,
	fireball = {
		type="default_spell",
		archetype=Constants.spell_archetypes.PROJECTILE,
		full_name = "Fireball",
		projectile_type = "fireball",
		description = "Launch a ball of fire",
		innate_effects = [
			],
		projectile_data = {
			damage = 5,
			speed = 400,
			range = 100,
		},
		frames = load("res://assets/sprites/spells/fireball_spell.tres"),
		max_mana = 100,
		cast_frequency = 0.5,
		#shoot_frequency = 0.1,
	},
	spark = {
		type = "spark",
		archetype=Constants.spell_archetypes.PROJECTILE,
		full_name = "Spark",
		projectile_type = "spark",
		description = "Launch 4 electric sparks that\nbounce on collision and move chaotically",
		innate_effects = [
			SparkSpellEffect.new(), 
			DeviateMovementDirection.new().init(deg_to_rad(30.0)), 
			BounceEffect.new()
		],
		projectile_data = { 
			damage = 5,
			speed = 500,
			range = 100,
		},
		frames = load("res://assets/sprites/spells/spark_spell.tres"),
		max_mana = 50,
		cast_frequency = 0.5,
	},
	icicle = {
		type = "icicle",
		archetype=Constants.spell_archetypes.PROJECTILE,
		full_name = "Icicle",
		projectile_type = "icicle",
		description = "Launch a piercing ice projectile",
		innate_effects = [
			PierceEffect.new(),
		],
		projectile_data = { 
			damage = 8,
			speed = 700,
			range = 100,
		},
		frames = load("res://assets/sprites/spells/icicle_spell.tres"),
		max_mana = 50,
		cast_frequency = 0.5,
	},
	heal = {
		type = "heal",
		archetype=Constants.spell_archetypes.ACTIVE,
		full_name = "Heal",
		projectile_type = "heal",
		description = "Launch a healing projectile that\nflies towards player",
		innate_effects = [
			ForceHostileFffect.new(),
			HomingEffect.new(),
		],
		projectile_data = { 
			damage = -1,
			speed = 700,
			range = 100,
		},
		frames = load("res://assets/sprites/spells/heal_spell.tres"),
		max_mana = 1,
		cast_frequency = 0.5,
	}
}
