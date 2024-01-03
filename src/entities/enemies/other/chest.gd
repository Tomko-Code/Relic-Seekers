class_name Chest
extends CharacterBody2D

@onready var _AnimatedSpriteComponent: AnimatedSpriteComponent = $Components/AnimatedSpriteComponent
@onready var _InteractibleComponent: InteractibleComponent = $Components/InteractableComponent

var loot_table: String = "standard_chest_loot"

func _ready():
	_InteractibleComponent.interacted.connect(_on_interaction, CONNECT_ONE_SHOT)

func _on_interaction():
	_AnimatedSpriteComponent.set_animation("opened")
	_InteractibleComponent.active = false
	_InteractibleComponent.hide()
	spawn_loot()
	
func spawn_loot():
	var loot_array = LootHandler.create_standard_loot(loot_table)
	for pickup in loot_array:
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		pickup.position = position + (random_direction * 10)
		pickup.push(random_direction)
		get_parent().call_deferred("add_child", pickup)
