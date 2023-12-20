class_name EntityRepulsionSystem
extends Node

@onready var parent = get_parent().get_parent()

@export var _HitboxComponent: HitboxComponent
@export var is_frozen: bool = false


func _physics_process(delta):
	var bodies = _HitboxComponent.get_overlapping_bodies()
	for body in bodies:
		parent.velocity += (parent.global_position - body.global_position).normalized()*32
