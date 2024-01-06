extends Node2D
class_name RoomConnection

var data:RoomConnectionData = null

func _ready():
	data.connection_opened.connect(on_opend)
	data.connection_closed.connect(on_closed)

func tp(body):
	if data.closed:
		return
	
	GameManager.game_camera.freeze_position()
	body.global_position += data.direction * 800
	GameManager.game_camera.unfreeze_position()
	
	var active_level:Level = GameManager.loaded_scenes["Game"].active_level 
	active_level.currnet_active_room.emit_signal("player_exit")
	
	active_level.currnet_active_room.set_physics_process(false)
	active_level.currnet_active_room.set_process(false)
	
	active_level.currnet_active_room = data.connected_room.spawned_room
	active_level.currnet_active_room.on_player_enter()

func _on_area_2d_body_entered(body):
	GameManager.game_camera.play_slow()
	call_deferred("tp",body)

func on_opend() -> void:
	$AnimationPlayer.play_backwards("Close")

func on_closed() -> void:
	$AnimationPlayer.play("Close")
