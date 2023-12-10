extends Node2D

var activated:bool = false
var starting_player_position:Vector2

func _ready():
	pass

func _on_interactable_component_interacted() -> void:
	if GameManager.player != null:
		
		GameManager.player.z_index = -1
		GameManager.player.paused = true
		GameManager.change_camera_parent(self)
		starting_player_position = GameManager.player.global_position
	
	activated = true
	$AnimationPlayer.play("Activated")

func _process(delta):
	if GameManager.player != null and activated:
		GameManager.player.global_position = starting_player_position + $Platform.position

func _on_animation_player_animation_finished(anim_name):
	GameManager.change_camera_parent(GameManager.player)
	GameManager.player.z_index = 1
	GameManager.player.paused = false
	GameManager.loaded_scenes["Game"].change_zone("zone_sanctuary_00", 0)
	GameManager.player.global_position = Vector2.ZERO
