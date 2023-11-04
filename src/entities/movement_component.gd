class_name MovementComponent
extends Node

var speed := 50000.0
var direction := Vector2.ZERO

@onready var parent: CharacterBody2D = get_parent().get_parent()

var is_idle := true


func _physics_process(delta):
	pass


func  get_direction():
	return direction
