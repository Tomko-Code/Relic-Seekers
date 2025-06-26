class_name ManaOrbPickup
extends GenericPickup

@export var _HitboxComponent: HitboxComponent

func _ready():
	_HitboxComponent.body_entered.connect(on_player_entered)
	super._ready()

func on_player_entered(player):
	if can_pickup:
		player = player as PlayerEntity
		var current_spell = GameData.save_file.player_inventory.get_current_spell() as Spell
		if current_spell != SpellsHandler.default_spell and current_spell.mana < current_spell.max_mana:
			@warning_ignore("narrowing_conversion")
			current_spell.change_mana(ceilf(current_spell.max_mana/2))
			AudioManager.play_sfx(AudioDB.soundID.sfx_mana_orb)
			queue_free()

func get_description():
	return "Mana Orb"

func get_title():
	return "Restore spell mana"
