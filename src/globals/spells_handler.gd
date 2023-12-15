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
	
	var effects = []
	if effects_pool:
		effects = SpellEffectsDb.random_effects_from_pool(effects_pool)
		
	for effect in effects:
		if effect is DirectSpellEffect:
			spell_data.effects = spell_data.get("effects", [])
			for existing_effect in spell_data.effects:
				if existing_effect.get_class() == effect.get_class():
					effect = null
					break
			if effect != null:
				spell_data.effects.append(effect)
			
		elif effect is ProjectileSpellEffect:
			spell_data.projectile_data = spell_data.get("projectile_data", {effects = []})
			for existing_effect in spell_data.projectile_data.effects:
				if existing_effect.get_class() == effect.get_class():
					effect = null
					break
			if effect != null:
				spell_data.projectile_data.effects.append(effect)
	
	spell.set_data(spell_data)
	
	return spell

func create_random_spell():
	var spell_name = GameManager.get_random_from_weighed_array(SpellsDb.random_pool)
	var spell = create_spell(spell_name, "random")
	return spell
	
