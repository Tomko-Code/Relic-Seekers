class_name SpikeTrap
extends CharacterBody2D

@export var damage_hitbox: HitboxComponent
@export var sprite: AnimatedSprite2D

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
	switching = false

func deactivate():
	switching = true
	sprite.animation_finished.connect(deactivate_callback, CONNECT_ONE_SHOT)
	sprite.play_backwards("default")

func deactivate_callback():
	damage_hitbox.monitorable = false
	damage_hitbox.monitoring = false
	switching = false