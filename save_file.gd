extends Resource
class_name SaveFile

signal secret_pilar_set(id: int, value: bool)
signal seecret_unlock_change(value: bool)

signal last_core

# Player
@export var player_inventory:PlayerInventory = PlayerInventory.new()

@export var max_health: int = 6
@export var current_health: int = max_health

# Run
@export var active_run:bool = false
@export var current_level:int = 0
@export var killed_enemies:int = 0

# Game
@export var prolog_complete:bool = false
@export var cores_placed:int = 0:
	set(value):
		cores_placed = value
		if cores_placed == 3:
			emit_signal("last_core")

@export var core_activation_data:Array[bool] = [false,false,false]
@export var portal_room_open:bool = false

@export var portal_room_open_onced:bool = false
# Show
@export var wave:int = 0

# Secret
@export var secret_pilar_array_id: Array[bool] = [true, false, true, false, false]
@export var secret_unlocked: bool = false
@export var first_cat_interaction: bool = false

#Extra dialogs
@export var first_shop_interaction: bool = false

func set_pilar(id: int, value: bool) -> void:
	secret_pilar_array_id[id] = value
	
	match id:
		0:
			secret_pilar_array_id[1] = !secret_pilar_array_id[1]
			secret_pilar_array_id[4] = !secret_pilar_array_id[4]
			
			secret_pilar_set.emit(1, secret_pilar_array_id[1])
			secret_pilar_set.emit(4, secret_pilar_array_id[4])
		1:
			secret_pilar_array_id[0] = !secret_pilar_array_id[0]
			secret_pilar_array_id[2] = !secret_pilar_array_id[2]
			
			secret_pilar_set.emit(0, secret_pilar_array_id[0])
			secret_pilar_set.emit(2, secret_pilar_array_id[2])
		2:
			secret_pilar_array_id[3] = !secret_pilar_array_id[3]
			secret_pilar_array_id[1] = !secret_pilar_array_id[1]
			
			secret_pilar_set.emit(3, secret_pilar_array_id[3])
			secret_pilar_set.emit(1, secret_pilar_array_id[1])
		3:
			secret_pilar_array_id[2] = !secret_pilar_array_id[2]
			secret_pilar_array_id[4] = !secret_pilar_array_id[4]
			
			secret_pilar_set.emit(2, secret_pilar_array_id[2])
			secret_pilar_set.emit(4, secret_pilar_array_id[4])
		4:
			secret_pilar_array_id[3] = !secret_pilar_array_id[3]
			secret_pilar_array_id[0] = !secret_pilar_array_id[0]
			
			secret_pilar_set.emit(3, secret_pilar_array_id[3])
			secret_pilar_set.emit(0, secret_pilar_array_id[0])
	
	secret_pilar_set.emit(id, value)
	update_secret_unlock()

func update_secret_unlock() -> void:
	print(secret_pilar_array_id)
	for value in secret_pilar_array_id:
		if value == false:
			secret_unlocked = false
			seecret_unlock_change.emit(false)
			return
	
	secret_unlocked = true
	seecret_unlock_change.emit(true)

func get_total_cores() -> int:
	print(player_inventory.core + cores_placed)
	return player_inventory.core + cores_placed
