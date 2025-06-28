extends Node2D

@onready var parent = get_parent().get_parent()

@export var _UserMouseShootingComponent: UserMouseShootingComponent
@export var _UserMovementComponent: UserMovementComponent
@export var _PlayerCastingComponent: PlayerCastingComponent

var minumim_mouse_swap_time: float = 0.07
var mouse_swap_timer: float = 0

func _input(event):
	if mouse_swap_timer > minumim_mouse_swap_time:
		if Input.is_action_just_released("mouse_change_spell_up"):
			var slot:int = GameData.save_file.player_inventory.current_spell_slot
			slot -= 1
			if slot < 0:
				slot = 4
			GameData.save_file.player_inventory.change_current_spell(slot)
			mouse_swap_timer = 0
		
		if Input.is_action_just_released("muse_change_spell_down"):
			var slot:int = GameData.save_file.player_inventory.current_spell_slot
			slot += 1
			if slot > 4:
				slot = 0
			GameData.save_file.player_inventory.change_current_spell(slot)
			mouse_swap_timer = 0
			
	
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
		elif Input.is_action_just_pressed("drop_spell") and not event.is_echo():
			var spell = GameData.save_file.player_inventory.drop_spell()
			if spell != null:
				var spell_pickup = SpellsHandler.create_spell_pickup(spell)
				spell_pickup.position = parent.position
				parent.get_parent().call_deferred("add_child", spell_pickup)

func _physics_process(delta):
	mouse_swap_timer += delta
	
	_UserMouseShootingComponent.is_shooting = false
	_PlayerCastingComponent.is_casting = false
	if Input.is_action_pressed("shoot_left_click"):
		var current_spell = GameData.save_file.player_inventory.get_current_spell()
		if current_spell.archetype == Constants.spell_archetypes.PROJECTILE:
			_UserMouseShootingComponent.is_shooting = true
		elif current_spell.archetype == Constants.spell_archetypes.ACTIVE:
			_PlayerCastingComponent.is_casting = true

	_UserMovementComponent.input_direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		_UserMovementComponent.input_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		_UserMovementComponent.input_direction.x += 1
	if Input.is_action_pressed("move_up"):
		_UserMovementComponent.input_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		_UserMovementComponent.input_direction.y += 1
	_UserMovementComponent.input_direction = _UserMovementComponent.input_direction.normalized()

	if Input.is_action_pressed("dash") and _UserMovementComponent.get_direction() != Vector2.ZERO and _UserMovementComponent.can_dash:
		# TODO : big kek but for now it's fine
		_UserMovementComponent.das_start_pos = $"../../PitHitBox/CollisionShape2D".global_position
		_UserMovementComponent.can_dash = false
		_UserMovementComponent.is_dashing = true
