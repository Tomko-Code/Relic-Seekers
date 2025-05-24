extends Node2D
class_name TeleportPilar

@export var ID:int = 0

signal pilar_activated
signal pilar_deactivated

var is_pilar_activated:bool = false:
	set(value):
		is_pilar_activated = value
		GameData.save_file.core_activation_data[ID] = value

func _ready() -> void:
	if GameData.save_file.core_activation_data[ID]:
		is_pilar_activated = true
		$Core.show()

func _pilar_interacted() -> void:
	if is_pilar_activated:
		deactivate_pilar()
	else:
		activate_pilar()

func activate_pilar():
	if GameData.save_file.player_inventory.core <= 0:
		return
	
	GameData.save_file.player_inventory.core -= 1
	GameData.save_file.cores_placed += 1
	is_pilar_activated = true
	$Core.show()
	emit_signal("pilar_activated")

func deactivate_pilar():
	GameData.save_file.cores_placed -= 1
	add_child(PickupsHandler.create_core_pickup())
	is_pilar_activated = false
	$Core.hide()
	emit_signal("pilar_deactivated")
