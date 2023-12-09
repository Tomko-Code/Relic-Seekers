class_name MovementComponent
extends Node

var speed := 300.0
var direction := Vector2.ZERO

@onready var parent: CharacterBody2D = get_parent().get_parent()

var is_idle := true
var is_rotable := false

func _physics_process(delta):
	pass


func get_direction():
	return direction
