extends Node2D

@export var _UserMouseShootingComponent: UserMouseShootingComponent
@export var _UserMovementComponent: UserMovementComponent
@export var _PlayerCastingComponent: PlayerCastingComponent

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

func _physics_process(delta):
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
