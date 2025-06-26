class_name CorePickup
extends GenericPickup

@export var _HitboxComponent: HitboxComponent

func _ready():
	_HitboxComponent.body_entered.connect(on_player_entered)
	super._ready()

func on_player_entered(_player):
	
	if can_pickup and GameData.save_file.get_total_cores() < 3:
		GameData.save_file.player_inventory.core += 1
		AudioManager.play_sfx(AudioDB.soundID.sfx_gold)
		queue_free()
