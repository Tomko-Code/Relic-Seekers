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
	
	var level:PrologLevel = PrologLevel.new()
	level.set_up()
	
	await get_tree().process_frame
	GameManager.loaded_scenes["Game"].change_current_level(level)
	GameManager.loaded_scenes["Game"].change_active_to_current_level()
	GameManager.player.position = Vector2.ZERO
