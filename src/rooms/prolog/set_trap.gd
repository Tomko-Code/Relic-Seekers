extends Node2D

@export var trap:bool = false :set = set_trap
@export var traps:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_trap(trap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_trap(value:bool):
	trap = value
	if traps != null:
		for child in traps.get_children():
			child.active = value
