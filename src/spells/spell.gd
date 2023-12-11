class_name Spell
extends Node

signal out_of_ammo
signal ammo_changed

var type: String = "none"
var full_name: String = "None"
var projectile_type: String = "test_projectile_b"
var description: String = "Stub test Spell"

var ammo: int = 50

#/ dmg/ range/ speed/ flags
@export var projectile_data: Dictionary = {}
var frames: SpriteFrames = load("res://assets/sprites/spells/spell_a.tres")

@export var effects: Array = []

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
		emit_signal("ammo_changed")
	elif ammo == 0:
		return null
		emit_signal("out_of_ammo")
		
	return projectile
	
func set_data(spell_data: Dictionary):
	for key in spell_data.keys():
		set(key, spell_data[key])

func get_description():
	var full_description = description + "\n[center]**Modifiers**[/center]\n"
	for effect in effects:
		full_description += effect.get_description() + "\n[center]---------[/center]\n"
	if projectile_data.has("effects"):
		for effect in projectile_data["effects"]:
			full_description += effect.get_description() + "\n[center]---------[/center]\n"
	full_description = full_description.trim_suffix("\n[center]---------[/center]\n")
	return full_description

func get_title():
	return full_name
