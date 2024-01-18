class_name Enemy
extends CharacterBody2D

signal health_changed
signal death

var is_dead: bool = false
@export var loot_table: String = "standard_mob_loot"


func call_death():
	if not is_dead:
		emit_signal("death")
		GameData.save_file.killed_enemies += 1
		SoundManager.play_sfx("death_sfx")
		spawn_loot()
		queue_free()
		is_dead = true

func play_sfx(audio_player: AudioStreamPlayer):
		audio_player.finished.connect(audio_player.queue_free)
		remove_child(audio_player)
		get_parent().call_deferred("add_child", audio_player)
		audio_player.call_deferred("play")

func spawn_loot():
	var loot_array = LootHandler.create_standard_loot(loot_table)

	if EnemiesHandler.killed_enemies == 1:
		var spell = SpellsHandler.create_spell("fireball")
		spell.add_effect(ExtraProjectilesEffect.new().init(1))
		spell.add_effect(PierceEffect.new().init(1))
		var spell_pickup = SpellsHandler.create_spell_pickup(spell)
		loot_array.append(spell_pickup)
	
	for pickup in loot_array:
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		pickup.position = position + (random_direction * 10)
		pickup.push(random_direction)
		get_parent().call_deferred("add_child", pickup)
