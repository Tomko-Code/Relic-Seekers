class_name SpellPickup
extends Node2D

var spell: Spell = null

func set_spell(_spell: Spell):
	spell = _spell
	
	var interactable = $Components/InteractableComponent as InteractibleComponent
	$Components/AnimatedSpriteComponent/Sprite.sprite_frames = spell.frames
	$Components/AnimatedSpriteComponent/Sprite.play("default")
	
	interactable.interaction_descryption = spell.get_description()
	interactable.interaction_title = spell.get_title()
	
	interactable.interacted.connect(pickup_spell)
	
	interactable.update_box()


func pickup_spell():
	var player_stats: PlayerStatsComponent = GameManager.get_entity_component(GameManager.player, StatsComponent)[0]
	if not spell.projectile_data:
		spell.projectile_data = player_stats.get_projectile_data()
	player_stats.current_spell = spell
	queue_free()
