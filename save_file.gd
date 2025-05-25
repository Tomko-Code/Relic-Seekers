extends Resource
class_name SaveFile

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
@export var cores_placed:int = 0

@export var core_activation_data:Array[bool] = [false,false,false]
@export var portal_room_open:bool = false

# Show
@export var wave:int = 0

func get_total_cores() -> int:
	print(player_inventory.core + cores_placed)
	return player_inventory.core + cores_placed
