extends Node


func normalize_array(array : Array) -> void:
	var minVal  = array.min()
	var maxVal  = array.max()
	#for i in range(0, array.size()):
	#	array[i] = range_lerp(array[i], minVal, maxVal, 0.0, 1.0)
