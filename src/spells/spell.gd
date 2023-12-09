class_name Spell
extends RefCounted

signal out_of_ammo

var type: String = "none"
var full_name: String = "None"
var projectile_type: String = "test_projectile_b"
var description: String = "Stub test Spell"

var ammo: int = 50

#/ dmg/ range/ speed/ flags
var projectile_data: Dictionary = {}
var frames := load("res://assets/sprites/spells/spell_a.tres")
var effects: Array = []

var shoot_frequency: float = 0.5

var is_friendly = true

func spawn_projectile():
	var projectile: BaseProjectile
	if ammo != 0:
		projectile = ProjectilesHandler.spawn_projectile(projectile_type, is_friendly)
		projectile.initialize(projectile_data)
		for effect in effects:
			effect = effect as SpellEffect
			effect.apply_on_projectile(projectile)
	
	if ammo > 0:
		ammo -= 1
	if ammo == 0:
		emit_signal("out_of_ammo")
		
	return projectile
	
func set_data(spell_data: Dictionary):
	for key in spell_data.keys():
		set(key, spell_data[key])

func get_description():
	var full_description = description + "\n"
	for effect in effects:
		full_description += effect.get_description() + "\n*****\n"
	full_description = full_description.trim_suffix("\n*****\n")
	return full_description

func get_title():
	return full_name
