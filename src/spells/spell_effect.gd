class_name SpellEffect
extends Node

var texture = load("res://assets/art/icons/spell_effects/generic.png")	
var effect_type: Constants.effect_types = Constants.effect_types.NEUTRAL

func color_text(text: String):
	return "[color=%s]%s[/color]" % [get_color(true), text]

func apply_on_projectile(projectile: BaseProjectile):
	pass

func get_description():
	return "None:\nEmpty spell effect"

func get_bbcode_texture():
	return "[img=16x16]%s[/img]" % texture.resource_path

func get_color(get_string: bool = false):
	match effect_type:
		Constants.effect_types.POSITIVE:
			if get_string:
				return "lime_green"
			return Color.LIME_GREEN
		Constants.effect_types.NEGATIVE:
			if get_string:
				return "red"
			return Color.RED
		Constants.effect_types.NEUTRAL:
			if get_string:
				return "dodger_blue"
			return Color.DODGER_BLUE
