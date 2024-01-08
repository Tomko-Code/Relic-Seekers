extends Resource
class_name LevelGenerationPreset

enum ROOM_RANOMIZE_SETTINGS { 
	FULL_RANDOM, 
	EQUAL_CHANCE_SHAPE, 
	BY_ROOM_WEIGHT, 
	BY_SHAPE_WEIGHT, 
	BY_SHAPE_ROOM_WEIGHT
}

var room_randomize_setting = ROOM_RANOMIZE_SETTINGS.BY_SHAPE_ROOM_WEIGHT

@export var level_name:String = "no_name"
@export var level_size:Vector2 = Vector2(10,10)

@export var min_rooms:int = 10
@export var max_rooms:int = 10

@export var start_position:Vector2 = Vector2(4,4)
@export var random_start:bool = false

@export var start_room:String = ""
@export var end_room:String = ""

@export var room_sets = []

@export var difficulty = 1

@export var shape_weights:Dictionary = {
	"1x1": 150,
	"1x2": 20,
	"2x1": 20,
	"2x2": 25,
	"l1" : 10,
	"l2" : 10,
	"l3" : 10,
	"l4" : 10
}

@export var special_rooms:Dictionary = {
	
}
