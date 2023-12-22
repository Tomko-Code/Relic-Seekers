class_name GenericParticles
extends CPUParticles2D

@export var wait_time: float = 0.

func run():
	emitting = true
	if not is_node_ready():
		await ready
	if wait_time == 0.:
		$Timer.start(lifetime * (lifetime_randomness+1))
	else:
		$Timer.start(wait_time)

func _on_timer_timeout():
	queue_free()
