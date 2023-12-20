class_name GenericPickup
#scene class
extends CharacterBody2D

@export var auto_pick: bool = false
@export var can_pickup: bool = false
@export var _PickupRepulsionMovement: PickupRepulsionMovement
@export var is_frozen: bool = false:
	set(value):
		is_frozen = value
		_PickupRepulsionMovement.is_frozen = value

var despawn_timer = Timer.new()

func _ready():
	_PickupRepulsionMovement.is_frozen = is_frozen
	var timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(pickup_unlock.bind(timer))
	add_child(timer)
	timer.start(0.5)
	
	despawn_timer.autostart = true
	despawn_timer.wait_time = 60
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(delete)
	add_child(despawn_timer)

func _process(delta):
	if auto_pick:
		position += global_position.direction_to(GameManager.player.global_position).normalized() * delta * 200

func pause_despawn():
	despawn_timer.paused = !despawn_timer.paused

func delete():
	queue_free()

func pickup_unlock(timer: Timer):
	timer.queue_free()
	can_pickup = true

func push(push_direction: Vector2, push_strength: float = 150):
	if _PickupRepulsionMovement:
		_PickupRepulsionMovement.push(push_direction, push_strength)
