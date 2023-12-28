extends Resource
class_name LevelGenerationPreset

@export var level_name:String = "null"
@export var level_size:Vector2 = Vector2.ZERO

@export var min_rooms:int = 0
@export var max_rooms:int = 0

@export var start_position:Vector2 = Vector2.ZERO
@export var random_start:bool = false

@export var start_room:String = ""
@export var end_room:String = ""

@export var room_sets = []
