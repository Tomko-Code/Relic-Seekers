class_name GoldenClockArtifact
extends ActiveArtifact


func _init():
	max_charge = 10

func use():
	var player_stats = GameManager.get_entity_component(GameManager.player, PlayerStatsComponent)[0] as PlayerStatsComponent
	var player_movement = GameManager.get_entity_component(GameManager.player, UserMovementComponent)[0] as UserMovementComponent
	
	player_movement.speed *= 1.25
	
	
	var shadow_timer = Timer.new()
	shadow_timer.timeout.connect(spawn_shadow)
	
	
	var timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(on_timeout.bind(shadow_timer, timer))
	
	
	GameManager.get_node("/root").call_deferred("add_child",shadow_timer)
	GameManager.get_node("/root").call_deferred("add_child",timer)
	
	await shadow_timer.ready
	await timer.ready
	
	shadow_timer.start(0.05)
	timer.start(5.0)
	
	current_charge = 0
	emit_signal("used")

func spawn_shadow():
	var player_animated_sprite = GameManager.get_entity_component(GameManager.player, AnimatedSpriteComponent)[0] as AnimatedSpriteComponent
	if player_animated_sprite:
		var ghost = PlayerDashGhost.new()
		ghost.freeze_frame(player_animated_sprite)
		ghost.modulate = Color.DARK_GOLDENROD
		ghost.position = GameManager.player.position
		GameManager.player.get_parent().call_deferred("add_child", ghost)

func get_title():
	return "Golden Clock"

func get_description():
	return "Grants a 25% speed bost for 5 seconds."

func on_timeout(timer: Timer, timer2: Timer):
	timer.queue_free()
	timer2.queue_free()
	var player_stats = GameManager.get_entity_component(GameManager.player, PlayerStatsComponent)[0] as PlayerStatsComponent
	var player_movement = GameManager.get_entity_component(GameManager.player, UserMovementComponent)[0] as UserMovementComponent
	
	player_movement.speed /= 1.25
