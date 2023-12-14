extends Button

@onready var burn = preload("res://assets/shaders/burn.gdshader")

func _on_pressed():
	material = ShaderMaterial.new()
	material.shader = burn 
	material.set("shader_parameter/start_time", Time.get_ticks_msec()/1000.0)
	material.set("shader_parameter/end_time", (Time.get_ticks_msec()/1000.0) +3.5)
	material.set("shader_parameter/ash", Color(0.32544088363647, 0.3254409134388, 0.32544088363647))
	material.set("shader_parameter/fire", Color(0.71764707565308, 0.28627452254295, 0))
	
	$"../../ScrollContainer/MarginContainer/ScrollTexture".material = ShaderMaterial.new()
	$"../../ScrollContainer/MarginContainer/ScrollTexture".material.shader = burn 
	$"../../ScrollContainer/MarginContainer/ScrollTexture".material.set("shader_parameter/start_time", Time.get_ticks_msec()/1000.0)
	$"../../ScrollContainer/MarginContainer/ScrollTexture".material.set("shader_parameter/end_time", (Time.get_ticks_msec()/1000.0)+3.5)
	$"../../ScrollContainer/MarginContainer/ScrollTexture".material.set("shader_parameter/ash", Color(0.32544088363647, 0.3254409134388, 0.32544088363647))
	$"../../ScrollContainer/MarginContainer/ScrollTexture".material.set("shader_parameter/fire", Color(0.71764707565308, 0.28627452254295, 0))
	
	$"../../ScrollContainer/Label".material = ShaderMaterial.new()
	$"../../ScrollContainer/Label".material.shader = burn 
	$"../../ScrollContainer/Label".material.set("shader_parameter/start_time", Time.get_ticks_msec()/1000.0)
	$"../../ScrollContainer/Label".material.set("shader_parameter/end_time", (Time.get_ticks_msec()/1000.0)+2)
	$"../../ScrollContainer/Label".material.set("shader_parameter/ash", Color(0.32544088363647, 0.3254409134388, 0.32544088363647))
	$"../../ScrollContainer/Label".material.set("shader_parameter/fire", Color(0.71764707565308, 0.28627452254295, 0))
	
	$"../../AnimationPlayer".play("FadeOut")

func _on_animation_player_animation_finished(_anim_name):
	if GameManager.player != null:
		GameManager.player.paused = false
		
	GameManager.dialog_box.play("first_time_start")
	
	$"../../..".queue_free()
