extends Node2D
class_name SpawnerPoint

signal animation_end

@export var animation_player: AnimationPlayer

var room:Room = null
var enemy:Enemy = null

func _ready():
	$SpawnRandomDelay.wait_time = randf_range(0, 1)
	$SpawnRandomDelay.start()

func _enter_tree():
	pass

func _on_spawn_random_delay_timeout() -> void:
	$AnimationPlayer.play("show")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "show":
		$AnimationPlayer.play("hide")
		room.call_deferred("add_child", enemy)
	else:
		queue_free()
