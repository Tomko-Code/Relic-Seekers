class_name SpellEffect
extends Node

var texture = load("res://assets/art/icons/spell_effects/generic.png")	

func color_text(text: String):
	return "[color=lime_green]%s[/color]" % text

func apply_on_projectile(projectile: BaseProjectile):
	pass

func get_description():
	return "None:\nEmpty spell effect"

func get_bbcode_texture():
	return "[img=16x16]%s[/img]" % texture.resource_path
