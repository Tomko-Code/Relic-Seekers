class_name RestockInteractible
extends StaticBody2D

@onready var interactible = $Comopnents/InteractableComponent as InteractibleComponent

signal interacted

func _ready():
	interactible.interacted.connect(emit_interacted)

func emit_interacted():
	emit_signal("interacted")
