class_name ShrineRoom
extends Room

var shrines = [
	[load("res://src/entities/shrines/red_shrine.tscn"), 1],
	[load("res://src/entities/shrines/blue_shrine.tscn"), 2],
]

@onready var marker = $ShrineMarker

func _ready():
	var shrine_res = GameManager.get_random_from_weighed_array(shrines)
	var shrine: Shrine = shrine_res.instantiate()
	add_child(shrine)
	shrine.position = marker.position
	marker.hide()
