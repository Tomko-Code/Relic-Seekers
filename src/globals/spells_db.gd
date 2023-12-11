extends Node

var spells = {
	default_spell = {
		type= "default_spell",
		full_name = "Fireball",
		projectile_type = "fireball",
		description = "This the default fireball spell",
		projectile_data = {},
		frames = load("res://assets/sprites/spells/fireball_spell.tres"),
		effects = [],
		ammo = -1,
		shoot_frequency = 0.5,
	},
	test_spell = {
		type= "test_spell",
		full_name = "Test Spark",
		projectile_type = "test_projectile_b",
		description = "Test spark spell",
		projectile_data = { can_bounce = true, effects = [ProjectileSpeedBoostSpellEffect.new().init(2),], damage = 0.5, },
		frames = load("res://assets/sprites/spells/spell_a.tres"),
		effects = [SparkSpellEffect.new()],
		ammo = 50,
		shoot_frequency = 0.5,
	}
}
