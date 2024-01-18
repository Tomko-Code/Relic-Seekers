class_name CombatSystem
extends Node

@export var _HitboxComponent: HitboxComponent
@export var _StatsComponent: StatsComponent
@export var _MovementComponent: MovementComponent
@export var _EntityEffectsHandler: EntityEffectsHandler


func _ready():
	_HitboxComponent.area_entered.connect(_on_bullet_enter_hitbox)

func get_entity():
	return get_parent().get_parent()

func process_hit(projectile: BaseProjectile):
	process_entity(projectile)

func process_entity(entity):
	if _MovementComponent is UserMovementComponent:
		_MovementComponent = _MovementComponent as UserMovementComponent
		if _MovementComponent.is_dashing:
			return
	if entity is BaseProjectile and get_entity() in entity.already_hit:
		return
	if entity is ExplosionArea and get_entity() in entity.already_hit:
		return
	
	if _StatsComponent and (entity is BaseProjectile or entity is DamageArea):
		_StatsComponent.change_health(entity.damage)
		if _MovementComponent:
			_MovementComponent.recoil(entity)
	
	if _StatsComponent and entity is DamageArea:
		SoundManager.play_sfx("hit_sfx")
	
	if _StatsComponent is PlayerStatsComponent and entity is DamageArea:
		_StatsComponent = _StatsComponent as PlayerStatsComponent
		if not _StatsComponent.invulnerability_end.is_connected(re_check_area_damage):
			_StatsComponent.invulnerability_end.connect(re_check_area_damage)
	
	if _EntityEffectsHandler and entity is BaseProjectile:
		_EntityEffectsHandler.process_projctile_hit(entity)
	
	if entity is BaseProjectile:
		entity = entity as BaseProjectile
		entity.hit(get_entity())
		if entity.is_friendly:
			var artifact = GameData.save_file.player_inventory.active_artifact
			if artifact:
				artifact.add_charge(entity.damage)

#on projectile hit entity
func _on_bullet_enter_hitbox(_area):
	if _area is HitboxComponent:
		var hitbox: HitboxComponent = _area
		var entity = hitbox.get_entity()
		process_entity(entity)

func re_check_area_damage():
	_StatsComponent.invulnerability_end.disconnect(re_check_area_damage)
	for area in _HitboxComponent.get_overlapping_areas():
		_on_bullet_enter_hitbox(area)
