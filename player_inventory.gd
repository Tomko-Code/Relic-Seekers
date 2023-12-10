extends Resource
class_name PlayerInventory

signal gold_changed( value:int )
signal emeralds_changed( value:int )

signal spells_changed

@export var gold:int = 0
@export var emeralds:int = 0

#@export var artefact_0
#@export var artefact_1

@export var current_spell_slot:int = 0
@export var spells:Array[Spell] = [null,null,null,null,null]


func change_current_spell(value: int):
	current_spell_slot = clampi(value, 0, 4)
	if not get_current_spell():
		current_spell_slot = 0
	emit_signal("spells_changed")

func get_current_spell():
	return spells[current_spell_slot]

func add_spell(new_spell: Spell):
	for spell_slot_id in range(1,4):
		if spells[spell_slot_id] == null:
			spells[spell_slot_id] = new_spell
			emit_signal("spells_changed")
			return null
	
	var last_spell = spells.back()
	
	for spell_slot_id in range(3,1,-1):
		spells[spell_slot_id+1] = spells[spell_slot_id]
	spells[1] = new_spell
	emit_signal("spells_changed")
	return last_spell
	
