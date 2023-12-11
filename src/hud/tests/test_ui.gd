extends Control

func _ready():
	$TextureRect.texture = SpellsHandler.create_spell("test_spell").frames.get_frame_texture("default", 0)

