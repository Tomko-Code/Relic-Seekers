extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_edit_text_changed():
	var text_input = $Console/TextEdit
	if text_input.text.ends_with("\n"):
		ConsoleHandler.process_command(text_input.text.rstrip("\n"))
		text_input.clear()


func _on_button_pressed():
	GameManager.loaded_scenes["Game"].current_level.reveal_level()
	

func _on_button_2_pressed_death():
	GameManager.player.call_death()


func _on_button_3_pressed():
	GameData.save_file.player_inventory.gold += 50


func _on_button_4_pressed():
	GameData.save_file.player_inventory.emeralds += 50


func _on_button_5_pressed():
	var spell = SpellsHandler.create_spell("test_spell")
	spell.add_effect(MaxManaEffect.new().init(2))
	var spell_pickup = SpellsHandler.create_spell_pickup(spell)
	spell_pickup.position = GameManager.player.position
	GameManager.player.get_parent().call_deferred("add_child", spell_pickup)
	pass


func _on_button_6_pressed():
	var stats = GameManager.get_entity_component(GameManager.player, PlayerStatsComponent)[0] as PlayerStatsComponent
	stats.change_health(-(stats.max_health - stats.current_health))
