class_name PurchasableWrapper
extends Node2D

@export var cost_label: Label
var cost: int = 1
@export var _InteractibleComponent: InteractibleComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent
@export var _EntityShadowComponent: EntityShadowComponent
var object: Node2D
@export var placeholder_sprite: Sprite2D

func set_data(_object: Node2D, _cost: int):
	cost_label.text = str(_cost)
	cost = _cost
	object = _object
	
	if object.get_parent() != null:
		object.get_parent().call_deferred("remove_child", object)
	if object.has_method("get_title"):
		_InteractibleComponent.interaction_title = object.get_title()
	else:
		_InteractibleComponent.interaction_title = "Cost: %s" % cost
	if object.has_method("get_description"):
		_InteractibleComponent.interaction_descryption = object.get_description()
	else:
		_InteractibleComponent.interaction_descryption = ""
	
	var animated_sprite_res = GameManager.get_entity_component(object, AnimatedSpriteComponent)
	if animated_sprite_res:
		for sprite in animated_sprite_res[0].get_children():
			_AnimatedSpriteComponent.call_deferred("add_child", sprite.duplicate())
		placeholder_sprite.hide()
		if _EntityShadowComponent:
			_EntityShadowComponent.queue_redraw()
		
	
	_InteractibleComponent.update_box()

func on_interacted():
	if GameData.save_file.player_inventory.gold >= cost:
		GameData.save_file.player_inventory.gold -= cost
		object.position = position
		get_parent().call_deferred("add_child", object)
		queue_free()
		