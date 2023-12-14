class_name GenericPickup
#scene class
extends CharacterBody2D

@export var can_pickup: bool = false
@export var _PickupRepulsionMovement: PickupRepulsionMovement
@export var is_frozen: bool = false:
	set(value):
		is_frozen = value
		_PickupRepulsionMovement.is_frozen = value

func _ready():
	_PickupRepulsionMovement.is_frozen = is_frozen
	var timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(pickup_unlock.bind(timer))
	add_child(timer)
	timer.start(2.0)

func pickup_unlock(timer: Timer):
	timer.queue_free()
	can_pickup = true

func push(push_direction: Vector2, push_strength: float = 150):
	if _PickupRepulsionMovement:
		_PickupRepulsionMovement.push(push_direction, push_strength)
