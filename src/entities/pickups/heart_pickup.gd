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
		if player._PlayerStatsComponent.current_health < player._PlayerStatsComponent.max_health:
			player._PlayerStatsComponent.change_health(-1)
			SoundManager.play_sfx("heart_sfx")
			queue_free()

