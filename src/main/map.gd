extends CanvasLayer

@export var level_render:LevelRender = null

func _on_game_level_change(level:Level):
	level_render.render_level(level)
	level.default_room.emit_signal("player_enterd")
