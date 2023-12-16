class_name Cannon
extends Enemy

@export var _ShootInDirectionComponent: ShootInDirectionComponent

@export var shooting_direction: Constants.cross_directions:
	set(value):
		shooting_direction = value
		if not _ShootInDirectionComponent:
			await ready
		match value:
			Constants.all_directions.RIGHT:
				_ShootInDirectionComponent.shooting_direction = Vector2.RIGHT
			Constants.all_directions.LEFT:
				_ShootInDirectionComponent.shooting_direction = Vector2.LEFT
			Constants.all_directions.UP:
				_ShootInDirectionComponent.shooting_direction = Vector2.UP
			Constants.all_directions.DOWN:
				_ShootInDirectionComponent.shooting_direction = Vector2.DOWN
@export var shooting_enabled: bool = false :
	set(value):
		shooting_enabled = value
		if not _ShootInDirectionComponent:
			await ready
		_ShootInDirectionComponent.is_shooting = value
