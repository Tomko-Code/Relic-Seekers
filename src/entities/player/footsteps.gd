extends AudioStreamPlayer

func _process(_delta: float) -> void:
	if not get_parent().is_idle:
		if not playing:
			play()
			pitch_scale = 1 + randf_range(-0.15, 0.15)
	else:
		stop()
