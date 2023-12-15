class_name SpellTestSpawn
extends Marker2D

@export var spell_name: String
@export var random_spell:bool = false

func _ready():
	var spell 
	if random_spell:
		spell = SpellsHandler.create_random_spell()
	else:
		spell = SpellsHandler.create_spell(spell_name)
	var spell_pickup = SpellsHandler.create_spell_pickup(spell)
	spell_pickup.position = position
	get_parent().call_deferred("add_child", spell_pickup)
	queue_free()
