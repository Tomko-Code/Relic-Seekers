extends Node


func weight_array(array : Array) -> void:
	var min_weight:float = array.min()
	var total_weight:float = 0.0
	
	for weight in array:
		total_weight += weight
