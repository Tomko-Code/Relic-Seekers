class_name SpellContainer
extends PanelContainer

@export var show_mana: bool = true
@export var shortcut:String = ""
@export var mana:String = ""

@export var slot_index: int = -1

var spell: Spell

func _ready():
	update_spell()
	update_selection()

func update_selection():
	#$Selection.visible = spell == GameData.save_file.player_inventory.get_current_spell() or slot_index == GameData.save_file.player_inventory.current_spell_slot
	$Selection.visible = slot_index == GameData.save_file.player_inventory.current_spell_slot

func update_spell():
	GameManager.detach_tooltip(self)
	if spell:
		GameManager.attach_tooltip(self, spell.get_tooltip, false)
		if spell.mana >= 0 and show_mana:
			$Mana.text = "%.0f/%.0f" % [spell.mana, spell.max_mana]
			$ManaCost.text = "%.2f" % spell.mana_cost
		else:
			$Mana.text = ""
			$ManaCost.text = ""
		$MarginContainer/Spell.texture = spell.frames.get_frame_texture("default", 0)
	else:
		#$MarginContainer/Spell.texture = load("res://assets/art/sprites/spells/non_spell.tres")
		$MarginContainer/Spell.texture = null
		$Shortcut.text = shortcut
		$Mana.text = mana
		$ManaCost.text = ""

func set_spell(_spell: Spell):
	if spell:
		spell.mana_changed.disconnect(update_spell)
	spell = _spell
	if spell:
		spell.mana_changed.connect(update_spell)
	update_spell()

func get_spell():
	return spell
