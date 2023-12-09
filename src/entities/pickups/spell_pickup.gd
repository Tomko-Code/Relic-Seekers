class_name SpellPickup
extends Node2D

var spell = null

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
	
	queue_free()
