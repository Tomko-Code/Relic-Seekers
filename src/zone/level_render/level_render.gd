extends Node2D
class_name LevelRender

@export var player_icon:Sprite2D

var current_level:Level = null

func _ready() -> void:
	pass

func render_level(level:Level) -> void:
	if current_level != null:
		clear_render()
	
	current_level = level
	
	# draw rooms
	for room in current_level.rooms:
		draw_room(room)
		
	
	# draw connections

func draw_room(room:Room) -> void:
	var render:RoomRender = RoomRender.new()
	render.room = room
	render.set_up()
	add_child(render)

func _process(delta):
	if GameManager.player != null:
		player_icon.position = GameManager.player.position/16

func clear_render() -> void:
	pass
