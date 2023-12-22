class_name SpikeTrap
extends CharacterBody2D

@onready var damage_hitbox: HitboxComponent = $Components/DamageHitbox
@onready var sprite: AnimatedSprite2D = $Components/AnimatedSpriteComponent/AnimatedSprite2D

var switching: bool = false
@export var active: bool = false :
	set(value):
		if not is_node_ready():
			await ready
		if switching:
			return
		else:
			active = value
			if active:
				activate()
			else:
				deactivate()

func _ready():
	pass

func activate():
	switching = true
	sprite.animation_finished.connect(active_callback, CONNECT_ONE_SHOT)
	sprite.play("default")
	
func active_callback():
	damage_hitbox.monitorable = true
	damage_hitbox.monitoring = true
	for body in damage_hitbox.get_overlapping_bodies():
		body.move_and_collide(Vector2(0.0001,0.0001))
	
	switching = false

func deactivate():
	switching = true
	sprite.animation_finished.connect(deactivate_callback, CONNECT_ONE_SHOT)
	sprite.play_backwards("default")

func deactivate_callback():
	damage_hitbox.monitorable = false
	damage_hitbox.monitoring = false
	switching = false
