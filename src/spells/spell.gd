class_name Spell
extends Node

signal out_of_mana
signal mana_changed

var type: String = "none"
var max_mana: float = -1
var mana:float = max_mana
var full_name: String = "None"
var projectile_type: String = "test_projectile_b"
var description: String = "Stub test Spell"

#/ dmg/ range/ speed/ flags
@export var projectile_data: Dictionary = {}
var frames: SpriteFrames = load("res://assets/sprites/spells/spell_a.tres")

@export var effects: Array = []

var shoot_frequency: float = 0.5

var is_friendly = true

func spawn_projectile():
	var projectile: BaseProjectile
	if mana != 0:
		projectile = ProjectilesHandler.spawn_projectile(projectile_type, is_friendly)
		
		projectile.initialize(projectile_data)
		for effect in effects:
			effect = effect as SpellEffect
			effect.apply_on_projectile(projectile)
	
	if mana > 0:
		mana = clamp(mana - 1, 0, max_mana)
		emit_signal("mana_changed")
	elif mana == 0:
		return null
		emit_signal("out_of_mana")
		
	return projectile
	
func set_data(spell_data: Dictionary):
	for key in spell_data.keys():
		set(key, spell_data[key])
	if projectile_type:
		projectile_data.merge(ProjectilesDb.projectiles[projectile_type])
	if max_mana >= 0:
		mana = max_mana

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

func change_mana(value: int):
	if mana >= 0:
		mana = clamp(mana + value, 0, max_mana)
		emit_signal("mana_changed")
