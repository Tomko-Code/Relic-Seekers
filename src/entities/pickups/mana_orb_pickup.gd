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
			current_spell.change_mana(ceilf(current_spell.max_mana/2))
			SoundManager.play_sfx("mana_orb_sfx")
			queue_free()

func get_description():
	return "Mana Orb"

func get_title():
	return "Restore spell mana"
