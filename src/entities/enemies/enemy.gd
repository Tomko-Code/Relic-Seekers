class_name Enemy
extends CharacterBody2D

signal health_changed
signal death


func call_death():
	emit_signal("death")
	SoundManager.play_sfx("death_sfx")
	spawn_loot()
	queue_free()

func play_sfx(audio_player: AudioStreamPlayer):
		audio_player.finished.connect(audio_player.queue_free)
		remove_child(audio_player)
		get_parent().call_deferred("add_child", audio_player)
		audio_player.call_deferred("play")

func spawn_loot():
	var spawn_gold:bool = randi() % 3 == 0
	var spawn_emerald:bool = randi() % 16 == 0
	var spawn_mana_orb:bool = randi() % 20 == 0
	var spawn_spell:bool = randi() % 25 == 0
	var spawn_artifact:bool = randi() % 25 == 0
	var spawn_heart:bool = randi() % 30 == 0
	
	
	if spawn_gold:
		var gold_pickup = PickupsHandler.create_gold_pickup() as GoldPickup
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		gold_pickup.position = position + (random_direction * 10)
		gold_pickup.push(random_direction)
		get_parent().call_deferred("add_child", gold_pickup)
		
	if spawn_emerald:
		var emerald_pickup = PickupsHandler.create_emerald_pickup() as EmeraldPickup
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		emerald_pickup.position = position + (random_direction * 10)
		emerald_pickup.push(random_direction)
		get_parent().call_deferred("add_child", emerald_pickup)
	
	if spawn_mana_orb:
		var mana_orb_pickup = PickupsHandler.create_mana_orb_pickup() as ManaOrbPickup
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		mana_orb_pickup.position = position + (random_direction * 10)
		mana_orb_pickup.push(random_direction)
		get_parent().call_deferred("add_child", mana_orb_pickup)
		
	if spawn_heart:
		var heart_pickup = PickupsHandler.create_heart_pickup() as HeartPickup
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		heart_pickup.position = position + (random_direction * 10)
		heart_pickup.push(random_direction)
		get_parent().call_deferred("add_child", heart_pickup)
	
	if spawn_spell:
		var spell = SpellsHandler.create_random_spell()
		var spell_pickup = SpellsHandler.create_spell_pickup(spell) as SpellPickup
		spell_pickup.position = position
		get_parent().call_deferred("add_child", spell_pickup)
	
	if spawn_artifact:
		var artifact = PickupsHandler.create_random_artifact()
		var artifact_pickup = PickupsHandler.create_artifact_pickup(artifact) as ArtifactPickup
		artifact_pickup.position = position
		get_parent().call_deferred("add_child", artifact_pickup)

