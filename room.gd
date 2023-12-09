extends RefCounted
class_name Room

# distance by rooms from the start
var depth:int

# cord on the map
var cord:Vector2 = Vector2.ZERO

# Example
# room_shape = [
#	[1, 1]
#	[1, 0]
#]
#
var room_shape = []

# Connections
var connection_arry = []
