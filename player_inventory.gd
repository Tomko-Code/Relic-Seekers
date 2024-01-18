extends Resource
class_name PlayerInventory

signal gold_changed( value:int )
signal emeralds_changed( value:int )

signal passive_artifact_changed
signal active_artifact_changed

signal spells_changed

@export var gold:int = 0:
	set(value):
		gold = value
		emit_signal("gold_changed")
@export var emeralds:int = 0:
	set(value):
		emeralds = value
		emit_signal("emeralds_changed")

#@export var artefact_0
#@export var artefact_1

@export var current_spell_slot:int = 0
@export var spells:Array[Spell] = [null,null,null,null,null]

@export var active_artifact: ActiveArtifact = null:
	set(value):
		active_artifact = value
		emit_signal("active_artifact_changed")
@export var passive_artifact: PassiveArtifact = null:
	set(value):
		passive_artifact = value
		emit_signal("passive_artifact_changed")

func change_current_spell(value: int):
	current_spell_slot = clampi(value, 0, 4)
	#if not get_current_spell():
	#	current_spell_slot = 0
	emit_signal("spells_changed")

func get_current_spell(include_default = true) -> Spell:
	var spell = spells[current_spell_slot]
	if current_spell_slot > 0 and not spell == null:
		return spell
	if include_default:
		return spells[0]
	else:
		return null

func add_spell(new_spell: Spell):

	if current_spell_slot == 0:
		for spell_slot_id in range(1,5):
			if spells[spell_slot_id] == null:
				spells[spell_slot_id] = new_spell
				emit_signal("spells_changed")
				return null
		var last_spell = spells.back()
		for spell_slot_id in range(3,0,-1):
			spells[spell_slot_id+1] = spells[spell_slot_id]
		spells[1] = new_spell
		emit_signal("spells_changed")
		return last_spell
	else:
		var old_spell = spells[current_spell_slot]
		spells[current_spell_slot] = new_spell
		emit_signal("spells_changed")
		return old_spell

func add_artifact(artifact: Artifact):
	if artifact is ActiveArtifact:
		var old_artifact = active_artifact
		active_artifact = artifact
		if old_artifact != null:
			return old_artifact
	
	elif artifact is PassiveArtifact:
		var old_artifact = passive_artifact
		if old_artifact != null:
			old_artifact.disable()
		passive_artifact = artifact
		artifact.enable()
		if old_artifact != null:
			return old_artifact
	
	return null

func drop_spell() -> Spell:
	if get_current_spell() == SpellsHandler.default_spell:
		return null
	else:
		var spell = get_current_spell()
		spells[current_spell_slot] = null
		emit_signal("spells_changed")
		return spell

func reset():
	for spell in spells:
		if spell != SpellsHandler.default_spell and spell != null:
			spell.queue_free()
	
	spells = [SpellsHandler.default_spell, null, null, null, null]
	current_spell_slot = 0
	gold = 0
	emeralds = 0
	
	if active_artifact != null:
		active_artifact.queue_free()
		active_artifact = null
	if passive_artifact != null:
		passive_artifact.queue_free()
		passive_artifact = null
	
	SpellsDb.get_death_ray()
	
	emit_signal("spells_changed")
	
