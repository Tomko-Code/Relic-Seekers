extends Node

var spells = {
	default_spell = {
		type= "default_spell",
		full_name = "Default Spell",
		projectile_type = "test_projectile_a",
		description = "This Is A Default Spell",
		projectile_data = {},
		frames = load("res://assets/sprites/spells/spell_a.tres"),
		effects = [],
		ammo = -1,
		shoot_frequency = 0.5,
	},
	test_spell = {
		type= "test_spell",
		full_name = "Test Spell",
		projectile_type = "test_projectile_b",
		description = "This Is A Test Spell",
		projectile_data = { can_bounce = true },
		frames = load("res://assets/sprites/spells/spell_a.tres"),
		effects = [SparkSpellEffect.new()],
		ammo = -1,
		shoot_frequency = 0.5,
	}
}
