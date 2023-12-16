class_name SpellTestSpawn
extends Marker2D

@export var spell_name: String
@export var random_spell:bool = false
@export var is_purchasable:bool = false
@export var cost:int = 2

func _ready():
	var spell 
	if random_spell:
		spell = SpellsHandler.create_random_spell()
	else:
		spell = SpellsHandler.create_spell(spell_name)
	var spell_pickup = SpellsHandler.create_spell_pickup(spell)
	
	if is_purchasable:
		spell_pickup = PickupsHandler.make_purchasable(spell_pickup, cost)
	spell_pickup.position = position
	get_parent().call_deferred("add_child", spell_pickup)
	queue_free()
