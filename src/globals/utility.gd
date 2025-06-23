extends Node

func get_level_name() -> String:
	var game: Game = GameManager.loaded_scenes["Game"]
	
	if game.level_state == game.LEVEL_STATES.SANCTUARY:
		return "SanctuaryLevel"
	else:
		return game.current_level.name

func weight_array(array : Array) -> void:
	var _min_weight:float = array.min()
	var _total_weight:float = 0.0
	
	for weight in array:
		_total_weight += weight
