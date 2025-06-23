extends Area2D

@export var direction:Vector2 = Vector2.ZERO
@export var distance_travel:float = 0

var is_open:bool = false

func _ready() -> void:
	pass

func _enter_tree() -> void:
	GameData.save_file.seecret_unlock_change.connect(_on_seecret_unlock_change)
	_on_seecret_unlock_change(GameData.save_file.secret_unlocked)

func _exit_tree() -> void:
	GameData.save_file.seecret_unlock_change.disconnect(_on_seecret_unlock_change)

func _on_seecret_unlock_change(value: bool) -> void:
	if is_open == value:
		return
	
	if not is_inside_tree():
		return
	
	is_open = value
	
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
	$AudioStreamPlayer2D.play()
	is_open = true
	$AnimationPlayer.play_backwards("Close")

func on_closed() -> void:
	$AudioStreamPlayer2D.play()
	is_open = false
	$AnimationPlayer.play("Close")

func _on_body_entered(body: Node2D) -> void:
	GameManager.game_camera.play_slow()
	call_deferred("tp",body)
