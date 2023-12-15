class_name ActiveArtifact
extends Artifact

var max_charge: float = 100
var current_charge: float = 0

signal used
signal charge_changed
signal ready_to_use

func use():
	pass

func can_use():
	return current_charge == max_charge

func get_title():
	return "Active Artifact"

func get_description():
	return "Active Artifact Description"

func add_charge(value):
	if not can_use():
		current_charge += value
		current_charge = clamp(current_charge, 0, max_charge)
		emit_signal("charge_changed")
		if current_charge == max_charge:
			emit_signal("ready_to_use")
	
