extends Node

var spell_pickup_resource = load("res://src/entities/pickups/spell_pickup.tscn")
@onready var default_spell = create_spell("default_spell")
@onready var test_spell = create_spell("test_spell")

var all_spells: Array[Spell] = []

func _ready():
	GameData.save_file.player_inventory.spells[0] = default_spell

func create_spell_pickup(spell: Spell):
	var spell_pickup: SpellPickup = spell_pickup_resource.instantiate()
	spell_pickup.set_spell(spell)
	return spell_pickup

func add_spell(spell: Spell):
	all_spells.append(spell)
	call_deferred("add_child", spell)
	spell.tree_exiting.connect(remove_spell.bind(spell))

func remove_spell(spell: Spell):
	all_spells.erase(spell)

func create_spell(spell_name: String, effects_pool: String = ""):
	if not SpellsDb.spells.has(spell_name):
		push_error("Nonexistent spell: %s" % spell_name)
	var spell = Spell.new()
	var spell_data = SpellsDb.spells[spell_name].duplicate(true)
	
	var effects = []
	if effects_pool:
		effects = SpellEffectsDb.random_effects_for_spell_from_pool(effects_pool, spell)
	
	spell.set_data(spell_data)
	
	for effect in effects:
		spell.add_effect(effect)
	
	add_spell(spell)
	return spell

func create_random_spell():
	var spell_name = GameManager.get_random_from_weighed_array(SpellsDb.random_pool)
	var spell = create_spell(spell_name, "random")
	return spell

func _physics_process(delta):
	if GameManager.GAME_STATE == GameManager.GAME_STATES.GAME:
		for spell in all_spells:
			spell.progress_cooldown(delta)
