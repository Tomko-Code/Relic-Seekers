extends PanelContainer

@export var spells_container: Node
@export var artifacts_container: Node
@export var current_spell_slot: SpellContainer

var spell_slots = []
@onready var player_inventory: PlayerInventory = GameData.save_file.player_inventory

func _ready():
	player_inventory.spells_changed.connect(update_spells)
	update_spells()

func update_spells():
	spell_slots = spells_container.get_children()
	var slot_0 = spell_slots.pop_front() as SpellContainer
	slot_0.set_spell(SpellsHandler.default_spell)
	current_spell_slot.set_spell(player_inventory.get_current_spell())
	for spell in player_inventory.spells.slice(1):
		var spell_slot = spell_slots.pop_front() as SpellContainer
		spell_slot.set_spell(spell)
	
	spell_slots = spells_container.get_children()
	for spell_slot in spell_slots:
		spell_slot.update_selection()
