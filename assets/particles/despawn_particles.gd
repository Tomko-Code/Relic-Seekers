extends CPUParticles2D

func run():
	emitting = true
	await ready
	$Timer.start(lifetime * (lifetime_randomness+1))

func _on_timer_timeout():
	queue_free()
