extends Node2D

var activated:bool = false

func _on_interactable_component_interacted() -> void:
	if GameManager.player != null:
		GameManager.player.paused = true
	
	activated = true
	
	$AnimationPlayer.play("Activated")

func _process(delta):
	if GameManager.player != null and activated:
		GameManager.player.global_position = global_position
