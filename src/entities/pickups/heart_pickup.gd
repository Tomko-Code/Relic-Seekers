class_name HeartPickup
#scene class
extends GenericPickup

@export var _HitboxComponent: HitboxComponent

func _ready():
	_HitboxComponent.body_entered.connect(on_player_entered)
	super._ready()

func on_player_entered(player):
	if can_pickup:
		player = player as PlayerEntity
		player._PlayerStatsComponent.change_health(-1)
		queue_free()

