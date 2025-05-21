extends Node


func weight_array(array : Array) -> void:
	var _min_weight:float = array.min()
	var _total_weight:float = 0.0
	
	for weight in array:
		_total_weight += weight
