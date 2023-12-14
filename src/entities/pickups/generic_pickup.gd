class_name GenericPickup
#scene class
extends CharacterBody2D

@export var _PickupRepulsionMovement: PickupRepulsionMovement
@export var is_frozen: bool = false:
	set(value):
		is_frozen = value
		_PickupRepulsionMovement.is_frozen = value

func _ready():
	_PickupRepulsionMovement.is_frozen = is_frozen

func push(push_direction: Vector2, push_strength: float = 150):
	if _PickupRepulsionMovement:
		_PickupRepulsionMovement.push(push_direction, push_strength)
