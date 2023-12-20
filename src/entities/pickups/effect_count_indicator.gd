class_name EffectCountIndicator
extends Node2D

@export var spell: Spell = null:
	set(value):
		spell = value
		queue_redraw()

func _ready():
	queue_redraw()

func _draw():
	if spell == null:
		return
	
	var effects = spell.get_effects(false)
	var offset = (PI / float(effects.size()))/2
	for index in effects.size():
		var color = effects[index].get_color()
		draw_circle(-Vector2.from_angle(offset + (PI * float(index)/float(effects.size()))) * 24, 4, color)
