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
		if current_spell != SpellsHandler.default_spell:
			current_spell.add_mana(20)
			queue_free()
