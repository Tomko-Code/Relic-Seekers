extends Resource
class_name PlayerInventory

signal gold_changed( value:int )
signal emeralds_changed( value:int )

@export var gold:int
@export var emeralds:int

#@export var artefact_0
#@export var artefact_1

#@export var spells
