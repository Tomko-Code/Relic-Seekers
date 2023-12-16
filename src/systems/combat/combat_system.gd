class_name CombatSystem
extends Node

@export var _HitboxComponent: HitboxComponent
@export var _StatsComponent: StatsComponent
@export var _MovementComponent: MovementComponent


func _ready():
	_HitboxComponent.area_entered.connect(_on_bullet_enter_hitbox)

func get_entity():
	return get_parent().get_parent()

#on projectile hit entity
func _on_bullet_enter_hitbox(_area):
	if _MovementComponent is UserMovementComponent:
		_MovementComponent = _MovementComponent as UserMovementComponent
		if _MovementComponent.is_dashing:
			return
	if _area is HitboxComponent:
		var hitbox: HitboxComponent = _area
		var entity = hitbox.get_entity()
		if entity is BaseProjectile and get_entity() in entity.already_hit:
			return
			
		if _StatsComponent and (entity is BaseProjectile or entity is DamageArea):
			_StatsComponent.change_health(entity.damage)
			_MovementComponent.recoil(entity)
		
		if _StatsComponent is PlayerStatsComponent and entity is DamageArea:
			_StatsComponent.invulnerability_end.connect(re_check_area_damage)
		
		if entity is BaseProjectile:
			entity = entity as BaseProjectile
			entity.hit(get_entity())
			if entity.is_friendly:
				var artifact = GameData.save_file.player_inventory.active_artifact
				if artifact:
					artifact.add_charge(entity.damage)

func re_check_area_damage():
	_StatsComponent.invulnerability_end.disconnect(re_check_area_damage)
	for area in _HitboxComponent.get_overlapping_areas():
		_on_bullet_enter_hitbox(area)
