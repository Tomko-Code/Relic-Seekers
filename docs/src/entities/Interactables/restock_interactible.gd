extends Node2D

@onready var interactible = $Comopnents/InteractableComponent as InteractibleComponent

signal interacted

func _ready():
	interactible.interacted.connect(emit_signal, "interacted")
