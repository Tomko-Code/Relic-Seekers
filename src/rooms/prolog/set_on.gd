extends Node2D

@export var trap:bool = false :set = set_trap

# Called when the node enters the scene tree for the first time.
func _ready():
	set_trap(trap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_trap(value:bool):
	trap = value
	for child in get_children():
		child.trap = value
