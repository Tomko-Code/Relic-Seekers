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
	
	if shrine.get_title() == "Blue Shrine":
		for light in $Lights.get_children():
			light.color = Color(0, 0.68627452850342, 0.87450981140137)
	else:
		for light in $Lights.get_children():
			light.color = Color(0.99663370847702, 0.43853276968002, 0.50506579875946)
	
	add_child(shrine)
	shrine.position = marker.position
	marker.hide()
