extends Node

var spell_pickup_resource = load("res://src/entities/pickups/spell_pickup.tscn")
@onready var default_spell = create_spell("default_spell")


func _ready():
	GameData.save_file.player_inventory.spells[0] = default_spell

func create_spell_pickup(spell: Spell):
	var spell_pickup: SpellPickup = spell_pickup_resource.instantiate()
	spell_pickup.set_spell(spell)
	return spell_pickup
	

func create_spell(spell_name: String, effects_pool: String = ""):
	if not SpellsDb.spells.has(spell_name):
		push_error("Nonexistent spell: %s" % spell_name)
	var spell = Spell.new()
	var spell_data = SpellsDb.spells[spell_name]
	
	if effects_pool:
		spell_data.effects = SpellEffectsDb.random_effects_from_pool(effects_pool)
	
	spell.set_data(spell_data)
	
	return spell
