class_name PlayerStatsComponent
extends StatsComponent

var max_health: int = 6
var current_health: int = max_health

var shoot_speed: float = 500
var shoot_range: float = 50
var shoot_damage: int = 1

var is_invulnerable = false
var invulnerable_current_duration = 0
var invulnerable_max_duration = 1.0

var flash_max_duration = 0.08
var flash_current_duration = 0

var is_flashing = false
var cur_flash = true

@export var _AnimatedSpriteComponent: AnimatedSpriteComponent


func get_shoot_speed():
	return shoot_speed

func get_shoot_range():
	return shoot_range

func get_shoot_damage():
	return shoot_damage

func get_shoot_effects():
	return []
	
func get_health():
	return current_health

func change_health(value: int):
	current_health -= value
	
	if value > 0:
		make_invulnerable()
	
	parent.emit_signal("health_changed")
	
	if current_health <= 0:
		parent.emit_signal("death")

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
