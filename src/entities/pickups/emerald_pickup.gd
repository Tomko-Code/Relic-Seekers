class_name EmeraldPickup
#scene class
extends GenericPickup

@export var _HitboxComponent: HitboxComponent

func _ready():
	_HitboxComponent.body_entered.connect(on_player_entered)
	super._ready()

func on_player_entered(player):
	if can_pickup:
		player = player as PlayerEntity
		GameData.save_file.player_inventory.emeralds += 1
		SoundManager.play_sfx("emerald_sfx")
		queue_free()
