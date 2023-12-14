class_name SpellContainer
extends PanelContainer

@export var show_ammo: bool = true
@export var shortcut:String = ""
@export var ammo:String = ""

var spell: Spell

func _ready():
	update_spell()
	update_selection()

func update_selection():
	$Selection.visible = spell == GameData.save_file.player_inventory.get_current_spell()

func update_spell():
	if spell:
		if spell.ammo >= 0 and show_ammo:
			$Ammo.text = str(spell.ammo)
		else:
			$Ammo.text = ""
		$MarginContainer/Spell.texture = spell.frames.get_frame_texture("default", 0)
	else:
		#$MarginContainer/Spell.texture = load("res://assets/art/sprites/spells/non_spell.tres")
		$MarginContainer/Spell.texture = null
		$Shortcut.text = shortcut
		$Ammo.text = ammo

func set_spell(_spell: Spell):
	if spell:
		spell.ammo_changed.disconnect(update_spell)
	spell = _spell
	if spell:
		spell.ammo_changed.connect(update_spell)
	update_spell()

func get_spell():
	return spell
