extends Area2D

@export var direction:Vector2 = Vector2.ZERO
@export var distance_travel:float = 0

var is_open:bool = false

func _ready() -> void:
	is_open = GameData.save_file.portal_room_open
	
	if is_open:
		on_opend()
	else:
		on_closed()

func tp(body):
	if not is_open:
		return
	
	GameManager.game_camera.freeze_position()
	body.global_position += direction * distance_travel
	GameManager.game_camera.unfreeze_position()

func on_opend() -> void:
	GameData.save_file.portal_room_open = true
	is_open = true
	$AnimationPlayer.play_backwards("Close")

func on_closed() -> void:
	GameData.save_file.portal_room_open = false
	is_open = false
	$AnimationPlayer.play("Close")

func _on_body_entered(body: Node2D) -> void:
	GameManager.game_camera.play_slow()
	call_deferred("tp",body)
