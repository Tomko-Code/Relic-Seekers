class_name EntityEffectsHandler
extends Node2D

var shared_clock = Timer.new()

@export var _StatsComponent: StatsComponent

@onready var parent = get_parent().get_parent()
var on_fire_partices_resource = load("res://assets/particles/on_fire_particles.tscn")
var on_fire_particles: GenericParticles = null
var on_fire_damage:float = 0
var on_fire_counter: int = 0
var on_fire = false

func _ready():
	shared_clock.wait_time = 1.0
	shared_clock.autostart = true
	shared_clock.one_shot = false
	shared_clock.timeout.connect(process_effects)
	add_child(shared_clock)

func process_projctile_hit(bullet: BaseProjectile):
	var projectile_base_effect = Constants.damage_type_to_effect(bullet.damage_type)
	if projectile_base_effect != null:
		process_damage(
			(bullet.damage/4) * bullet.get_effect_damage_modifier(projectile_base_effect), 
			bullet.damage_type, 
			bullet.get_effect_chance_modifier(projectile_base_effect),
			)
	for entity_effect in bullet.entity_effects:
		process_entity_effect(
			entity_effect,
			{
				damage_value = bullet.damage * bullet.get_effect_damage_modifier(entity_effect),
				effect_chance_modifier = bullet.get_effect_chance_modifier(entity_effect),
			}
		)

func process_damage(damage_value: float,
	damage_type: Constants.damage_types, 
	effect_chance_modifier: float = 1):
	var data = { 
		damage_value = damage_value,
		effect_chance_modifier = effect_chance_modifier,
	}
	match damage_type:
		Constants.damage_types.FIRE:
			process_entity_effect(Constants.entity_effects.BURNING, data)

func process_entity_effect(effect: Constants.entity_effects, data: Dictionary):
	match effect:
		Constants.entity_effects.BURNING:
			if randf() < 0.25 * data.get("effect_chance_modifier", 1.0):
				set_on_fire(data.get("damage_value", 1.0))

func set_on_fire(damage_value):
	if on_fire and on_fire_damage >= damage_value:
		return
	if not on_fire_particles:
		var on_fire_particles = on_fire_partices_resource.instantiate()
		on_fire_particles.tree_exiting.connect(clear_fire_particles)
		on_fire_particles.run()
		parent.call_deferred("add_child", on_fire_particles)
	else:
		on_fire_particles.run()
	on_fire_damage = damage_value
	on_fire_counter = 0
	on_fire = true

func clear_fire_particles():
	on_fire_particles = null

func process_effects():
	if on_fire:
		on_fire_counter += 1
		_StatsComponent.change_health(on_fire_damage)
