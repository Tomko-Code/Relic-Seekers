class_name PlayerCastingComponent
extends Node2D

signal on_cast

@onready var parent = get_parent().get_parent()

var is_casting: bool = false
var casting_frequency_current = 0

func cast():
	var current_spell = GameData.save_file.player_inventory.get_current_spell()
	current_spell.activate()

func _physics_process(delta):
	if parent.paused:
		return
	if is_casting and GameData.save_file.player_inventory.get_current_spell().can_cast():
		cast()

	
