class_name Shrine
extends Node2D

@onready var _InteractibleComponent: InteractibleComponent = $Components/InteractableComponent

func _ready():
	_InteractibleComponent.interacted.connect(_on_interacted)
	_InteractibleComponent.interaction_title = get_title()
	_InteractibleComponent.interaction_descryption = get_description()
	_InteractibleComponent.update_box()

func can_apply_on_spell(spell: Spell) -> bool:
	return false

func apply_on_spell(spell: Spell):
	pass

func _on_interacted():
	var current_spell = GameData.save_file.player_inventory.get_current_spell(false)
	if current_spell == null:
		return
	if can_apply_on_spell(current_spell):
		apply_on_spell(current_spell)
		_InteractibleComponent.active = false
		_InteractibleComponent.hide()
		GameData.save_file.player_inventory.spells_changed.emit()

func get_description():
	return "A base Shrine"

func get_title():
	return "Shrine"
