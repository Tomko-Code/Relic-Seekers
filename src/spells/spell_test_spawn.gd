class_name SpellTestSpawn
extends Node2D

func _ready():
	var spell = SpellsHandler.create_spell("test_spell")
	var spell_pickup = SpellsHandler.create_spell_pickup(spell)
	spell_pickup.position = position
	get_parent().call_deferred("add_child", spell_pickup)
	
