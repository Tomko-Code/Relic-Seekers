class_name Spell
extends Node

signal out_of_mana
signal mana_changed
signal on_cast

var type: String = "none"
var archetype = Constants.spell_archetypes.PROJECTILE
var max_mana: float = -1
var mana:float = max_mana
var mana_cost: float = 1
var full_name: String = "None"
var projectile_type: String = "test_projectile_b"
var description: String = "Stub test Spell"

var innate_effects: Array = []
#/ dmg/ range/ speed/ flags
@export var projectile_data: Dictionary = {}
var frames: SpriteFrames = load("res://assets/sprites/spells/spell_a.tres")

@export var effects: Array = []

var cast_frequency: float = 0.5
var cast_frequency_current: float = cast_frequency

var is_friendly = true

func spawn_projectile():
	var projectile: BaseProjectile = null
	
	if lose_mana():
		projectile = ProjectilesHandler.spawn_projectile(projectile_type, is_friendly)
		
		projectile.initialize(projectile_data)
		for effect in effects:
			effect = effect as SpellEffect
			effect.apply_on_projectile(projectile)
	
		SoundManager.play_sfx("shoot_sfx")
		emit_signal("on_cast")
		return projectile
	return null

func activate():
	if lose_mana():
		for effect in effects:
			effect = effect as DirectSpellEffect
			effect.use(self)
		emit_signal("on_cast")

func progress_cooldown(value):
	cast_frequency_current = minf(cast_frequency_current + value, cast_frequency)

func get_remaining_cooldown():
	return cast_frequency_current

func can_cast():
	return cast_frequency_current == cast_frequency

func lose_mana() -> bool:
	if mana > mana_cost:
		mana = clamp(mana - mana_cost, 0, max_mana)
		cast_frequency_current = 0
		emit_signal("mana_changed")
		return true
	elif mana == 0:
		emit_signal("out_of_mana")
		return false
	cast_frequency_current = 0
	return true
	
func set_data(spell_data: Dictionary):
	for key in spell_data.keys():
		set(key, spell_data[key])
	if projectile_type:
		projectile_data.merge(ProjectilesDb.projectiles[projectile_type])
	if max_mana >= 0:
		mana = max_mana
	for effect in innate_effects:
		add_effect(effect)

func has_effect(effect: SpellEffect, exact_match:bool = false):
	if effect is DirectSpellEffect:
		for existing_effect in effects:
			if existing_effect.get_script() == effect.get_script():
				return true
	elif effect is ProjectileSpellEffect:
		for existing_effect in projectile_data.get("effects", []):
			if existing_effect.get_script() == effect.get_script():
				return true
	return false

func add_effect(effect: SpellEffect, force: bool = false):
	if not force and has_effect(effect) and not effect.check_conditions(self):
		return
	if effect is DirectSpellEffect:
		effect.apply_on_spell(self)
		effects.append(effect)
	elif effect is ProjectileSpellEffect:
		projectile_data.effects = projectile_data.get("effects", [])
		projectile_data.effects.append(effect)

func is_innate(effect: SpellEffect):
	for innate_effect in innate_effects:
		if innate_effect.get_script() == effect.get_script():
			return true
	return false

func get_description():
	var desc_effects = get_effects(false)
	if desc_effects:
		var full_description = description + "\n[color=yellow]**Modifiers[/color]\n"
		for effect in desc_effects:
			full_description += effect.get_description() + "\n"
	#	full_description = full_description.trim_suffix("\n[center]---------[/center]\n")
		full_description = full_description.trim_suffix("\n")
		full_description = full_description.trim_suffix("\n[color=yellow]**Modifiers:[/color]\n")
		return full_description
	else:
		return description

func get_effects(include_innate: bool) -> Array:
	var all_effects = effects + projectile_data.get("effects", []) as Array[SpellEffect]
	if not include_innate:
		var ret_effects : Array[SpellEffect] = []
		for effect in all_effects:
			if not is_innate(effect):
				ret_effects.append(effect)
		return ret_effects
	return all_effects

func get_title():
	return full_name

func change_mana(value: int):
	if mana >= 0:
		mana = clamp(mana + value, 0, max_mana)
		emit_signal("mana_changed")
