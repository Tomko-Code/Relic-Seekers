class_name HealEffect
extends DirectSpellEffect

func use(spell):
	var active_particles = load("res://assets/particles/active_particles.tscn").instantiate() as CPUParticles2D
	GameManager.player._PlayerStatsComponent.change_health(-1)
	active_particles.position = GameManager.player.position
	active_particles.color = Color.LAWN_GREEN
	GameManager.player.get_parent().call_deferred("add_child", active_particles)
	SoundManager.play_sfx("heart_sfx")
	active_particles.run()
