extends Room

var cat_res = load("res://src/seecret/cat.tscn")

func _ready():
	GameManager.game_camera.limit = true
	
	if GameData.save_file.first_cat_interaction and GameManager.level_depth == 1:
		print("add spell")
		var spell  = SpellsHandler.create_random_spell()
		var spell_pickup = SpellsHandler.create_spell_pickup(spell)
		
		spell_pickup.position = Vector2(550, 250)
		
		var cat:Cat = cat_res.instantiate()
		
		cat.position = Vector2(550, 400)
		
		call_deferred("add_child", cat)
		call_deferred("add_child", spell_pickup)
