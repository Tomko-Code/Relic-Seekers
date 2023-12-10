class_name PlayerStatsComponent
extends StatsComponent

var is_invulnerable = false
var invulnerable_current_duration = 0
var invulnerable_max_duration = 1.5

var flash_max_duration = 0.08
var flash_current_duration = 0

var is_flashing = false
var cur_flash = true

@export var _AnimatedSpriteComponent: AnimatedSpriteComponent

var default_spell: Spell = SpellsHandler.create_spell("default_spell")
var current_spell: Spell = default_spell
var spells: Array[Spell] = []

func _init():
	max_health = 6 as int
	current_health = max_health as int
	default_spell.projectile_data.merge(get_projectile_data())

func get_shoot_frequency():
	return current_spell.shoot_frequency

func get_health():
	return current_health

func change_health(value: int):
	if is_invulnerable and value > 0: 
		return
	current_health -= value
	
	if value > 0:
		make_invulnerable()
	
	parent.emit_signal("health_changed")
	
	if current_health <= 0:
		parent.call_death()

func make_invulnerable():
	is_invulnerable = true

func flash(active):
	if not is_flashing:
		is_flashing = true
		var white_shader_material = ShaderMaterial.new()
		var white_shader = load("res://assets/shaders/white.gdshader")
		white_shader_material.shader = white_shader
		_AnimatedSpriteComponent.material = white_shader_material
		
	_AnimatedSpriteComponent.material.set_shader_parameter("active", active)

func _physics_process(delta):
	if is_invulnerable:
		
		flash_current_duration += delta
		if flash_current_duration >= flash_max_duration:
			flash_current_duration = 0
			flash(cur_flash)
			cur_flash = !cur_flash
		
		invulnerable_current_duration += delta
		if invulnerable_current_duration >= invulnerable_max_duration:
			is_invulnerable = false
			is_flashing = false
			invulnerable_current_duration = 0
			_AnimatedSpriteComponent.material = null
