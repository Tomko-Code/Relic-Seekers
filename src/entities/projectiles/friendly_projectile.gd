class_name FriendlyProjectile
extends StaticBody2D


@export var _ProjectileMovementComponent: ProjectileMovementComponent


func launch(direction_vector: Vector2, speed: float):
	_ProjectileMovementComponent.launch(direction_vector, speed)