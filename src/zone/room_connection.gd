extends Node2D
class_name RoomConnection

var data:RoomConnectionData = null

func tp(body):
	body.global_position += data.direction * 800
	var active_level:Level = GameManager.loaded_scenes["Game"].active_level 
	active_level.currnet_active_room = data.connected_room.spawned_room
	active_level.currnet_active_room.on_player_enter()

func _on_area_2d_body_entered(body):
	GameManager.game_camera.play_slow()
	call_deferred("tp",body)
