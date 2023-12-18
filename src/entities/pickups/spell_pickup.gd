class_name SpellPickup
extends CharacterBody2D

var spell: Spell = null

func set_spell(_spell: Spell):
	spell = _spell
	
	var interactable = $Components/InteractableComponent as InteractibleComponent
	$Components/AnimatedSpriteComponent/Sprite.sprite_frames = spell.frames
	#$Components/AnimatedSpriteComponent/Sprite.play("default")
	
	interactable.interaction_descryption = spell.get_description()
	interactable.interaction_title = spell.get_title()
	
	interactable.interacted.connect(pickup_spell)
	
	interactable.update_box()


func pickup_spell():
	var player_stats: PlayerStatsComponent = GameManager.get_entity_component(GameManager.player, StatsComponent)[0]
	spell.projectile_data.merge(player_stats.get_projectile_data())
	#player_stats.current_spell = spell
	var ret_spell = GameData.save_file.player_inventory.add_spell(spell)
	if ret_spell:
		var new_pickup = SpellsHandler.create_spell_pickup(ret_spell)
		new_pickup.position = position
		get_parent().call_deferred("add_child", new_pickup)
	
	SoundManager.play_sfx("pickup_sfx")
	queue_free()

func get_description():
	return spell.get_description()

func get_title():
	return spell.get_title()
