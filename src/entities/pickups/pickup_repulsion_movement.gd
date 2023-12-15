class_name PickupRepulsionMovement
extends MovementComponent

@export var _HitboxComponent: HitboxComponent
@export var is_frozen: bool = false

func _ready():
	_HitboxComponent.area_entered.connect(collision)

func _physics_process(delta):
	parent.velocity = parent.velocity.lerp(Vector2.ZERO.normalized() * speed, 10 * delta)
	parent.move_and_slide()

func get_direction():
	return direction

func collision(hitbox: Area2D):
	if hitbox is HitboxComponent:
		var direction = parent.position - hitbox.get_entity().position
		push(direction, 150)

func push(push_direction: Vector2, push_strength: float = 150):
	if parent == null:
		await ready
	if not is_frozen:
		parent.velocity += push_strength * push_direction.normalized()
