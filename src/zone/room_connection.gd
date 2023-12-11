extends Node2D
class_name RoomConnection

var data:RoomConnectionData = null

func tp(body):
	body.global_position += data.direction * 800

func _on_area_2d_body_entered(body):
	GameManager.game_camera.play_slow()
	call_deferred("tp",body)
