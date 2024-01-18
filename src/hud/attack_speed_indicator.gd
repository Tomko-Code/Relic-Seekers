extends Control

var radius = 60

var timeout_frequency_max = 2.0
var timeout_frequency_current = 0

var spell: Spell

func _ready():
	update_spell()
	GameData.save_file.player_inventory.spells_changed.connect(update_spell)
	if get_parent() != get_node("/root"):
		var parent_size = get_parent().get_size()
		var higher_value = parent_size.x if parent_size.x > parent_size.y else parent_size.y
		radius = higher_value/2 - 8

func on_cast():
	timeout_frequency_current = 0
	set_process(true)

func update_spell():
	var old_spell = spell
	if old_spell:
		old_spell.on_cast.disconnect(on_cast)
	spell = GameData.save_file.player_inventory.get_current_spell()
	if spell != null:
		spell.on_cast.connect(on_cast)
		timeout_frequency_max = spell.cast_frequency
		timeout_frequency_current = spell.get_remaining_cooldown()
		set_process(true)

func _draw():
	draw_arc(Vector2.ZERO, radius, 0, 2*PI * (timeout_frequency_current/timeout_frequency_max),100,Color.RED,2,true)

func _process(delta):
	timeout_frequency_current = minf(timeout_frequency_current + delta, timeout_frequency_max)
	$DurationLabel.text = "%.1f" % timeout_frequency_current
	if spell.can_cast():
		timeout_frequency_current = 0
		set_process(false)
		$DurationLabel.text = ""
	queue_redraw()
