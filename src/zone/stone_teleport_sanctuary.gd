extends Node2D
class_name StoneTeleportSanctuary

@export var interactable_component:InteractibleComponent

func _ready():
	pass

func _on_interactable_component_interacted():
	print("Start new run")
