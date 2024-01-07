class_name Artifact
extends Node

var frames: SpriteFrames = load("res://assets/sprites/spells/fireball_spell.tres")


func get_tooltip():
	return [get_title(), get_description()]

func get_title():
	return "Artifact"

func get_description():
	return "Artifact Description"

func get_gold_value():
	return 20
