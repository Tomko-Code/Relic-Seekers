extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	GameManager.GAME_STATE = GameManager.GAME_STATES.GAME
	GameManager.switch_active_scene_to("Game")
	
	if GameManager.loaded_scenes["Game"].game_running:
		pass
	else:
		GameManager.loaded_scenes["Game"].start_game(Constants.STARTING_OPTIONS.NORMAL)


func _on_visibility_changed():
	if GameManager.loaded_scenes["Game"].game_running:
		text = "Continue ..."
	else:
		text = "Start"
