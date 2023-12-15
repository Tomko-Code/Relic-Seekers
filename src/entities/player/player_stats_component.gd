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

var current_spell: Spell = GameData.save_file.player_inventory.get_current_spell()

func _init():
	max_health = GameData.save_file.max_health
	current_health = GameData.save_file.current_health
	SpellsHandler.default_spell.projectile_data.merge(get_projectile_data())

func _ready():
	GameData.save_file.player_inventory.spells_changed.connect(update_current_spell)

func update_current_spell():
	current_spell = GameData.save_file.player_inventory.get_current_spell()

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("spell_slot_0") and not event.is_echo():
			GameData.save_file.player_inventory.change_current_spell(0)
		elif Input.is_action_just_pressed("spell_slot_1") and not event.is_echo():
			GameData.save_file.player_inventory.change_current_spell(1)
		elif Input.is_action_just_pressed("spell_slot_2") and not event.is_echo():
			GameData.save_file.player_inventory.change_current_spell(2)
		elif Input.is_action_just_pressed("spell_slot_3") and not event.is_echo():
			GameData.save_file.player_inventory.change_current_spell(3)
		elif Input.is_action_just_pressed("spell_slot_4") and not event.is_echo():
			GameData.save_file.player_inventory.change_current_spell(4)
		elif Input.is_action_just_pressed("artifact_slot_q") and not event.is_echo():
			var artifact = GameData.save_file.player_inventory.active_artifact
			if artifact != null and artifact.can_use():
				artifact.use()

func get_shoot_frequency():
	return current_spell.shoot_frequency

func get_health():
	return current_health

func change_health(value):
	value = round(value)
	if is_invulnerable and value > 0: 
		return
	current_health = clamp(current_health - value, 0, max_health)
	
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
