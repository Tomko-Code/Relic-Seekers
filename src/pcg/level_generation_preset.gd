extends Resource
class_name LevelGenerationPreset

@export var level_name:String = "no_name"
@export var level_size:Vector2 = Vector2(5,5)

@export var min_rooms:int = 5
@export var max_rooms:int = 10

@export var start_position:Vector2 = Vector2(2,2)
@export var random_start:bool = false

@export var start_room:String = ""
@export var end_room:String = ""

@export var room_sets = []
