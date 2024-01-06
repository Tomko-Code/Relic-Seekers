class_name SpellPickup
extends GenericPickup

var spell: Spell = null

@export var _AnimatedSpriteComponent: AnimatedSpriteComponent

func get_gold_value():
	if spell:
		return spell.get_gold_value()
	else:
		return super.get_gold_value()

func _ready():
	if get_parent() == get_node("/root"):
		set_spell(SpellsHandler.test_spell)
		add_child(Camera2D.new())
	super._ready()

func set_spell(_spell: Spell):
	spell = _spell
	
	var interactable = $Components/InteractableComponent as InteractibleComponent
	$Components/AnimatedSpriteComponent/Sprite.sprite_frames = spell.frames
	$Components/AnimatedSpriteComponent/EffectCountIndicator.spell = spell
	#$Components/AnimatedSpriteComponent/Sprite.play("default")
	
	interactable.interaction_descryption = spell.get_description()
	interactable.interaction_title = spell.get_title()
	
	interactable.interacted.connect(pickup_spell)
	
#	var effects = spell.get_effects(false) as Array
#	for index in effects.size():
#		var effect = effects[index]
#		var sprite = Sprite2D.new()
#		sprite.offset = Vector2.from_angle((PI*2.0)*(index as float/effects.size() as float) - PI/4).normalized() * 24
#		sprite.texture = effect.texture
#		if is_node_ready():
#			_AnimatedSpriteComponent.call_deferred("add_child", sprite)
#		else:
#			_AnimatedSpriteComponent.add_child(sprite)
	
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

func delete():
	if spell != null:
		spell.queue_free()
	queue_free()

func get_description():
	return spell.get_description()

func get_title():
	return spell.get_title()
