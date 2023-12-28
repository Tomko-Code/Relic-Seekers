extends Node2D
class_name LevelRender

@export var player_icon:Sprite2D
@export var camera:Camera2D

@export var render_player_icon:bool = true :
	set(value):
		render_player_icon = value
		player_icon.visible = value

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

func draw_room(room:Room) -> void:
	var render:RoomRender = RoomRender.new()
	render.room = room
	render.set_up()
	$Rooms.add_child(render)

func _process(delta):
	if GameManager.player != null:
		player_icon.position = GameManager.player.position/16

func clear_render() -> void:
	for child in $Rooms.get_children():
		child.hide()
		child.queue_free()
