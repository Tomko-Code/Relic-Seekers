extends Resource
class_name SaveFile

# Player
@export var player_inventory:PlayerInventory = PlayerInventory.new()

@export var max_health: int = 6
@export var current_health: int = max_health

# Game
@export var active_run:bool = false
@export var prolog_complete:bool = false
@export var current_level:int = 0

# Show
@export var wave:int = 0
