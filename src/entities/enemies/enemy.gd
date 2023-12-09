class_name Enemy
extends CharacterBody2D

signal death

func _ready():
	pass

func call_death():
	emit_signal("death")
	queue_free()
