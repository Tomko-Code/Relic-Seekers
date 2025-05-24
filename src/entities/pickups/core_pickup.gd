class_name CorePickup
extends GenericPickup

@export var _HitboxComponent: HitboxComponent

func _ready():
	_HitboxComponent.body_entered.connect(on_player_entered)
	super._ready()

func on_player_entered(player):
	if can_pickup:
		GameData.save_file.player_inventory.core += 1
		SoundManager.play_sfx("gold_sfx")
		queue_free()
