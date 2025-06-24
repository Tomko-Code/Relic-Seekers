extends SubViewportContainer

var camera_start_pos:Vector2 = Vector2.ZERO 
var click_start_pos:Vector2 = Vector2.ZERO 
var mouse_drag:bool = false

func _process(delta):
	if $"../..".map_open == true:
		if Input.is_action_just_released("LMB_pressed"):
			mouse_drag = false
		
		if Input.is_action_just_pressed("LMB_pressed"):
			camera_start_pos = $SubViewport/level_render.camera.position
			click_start_pos = get_global_mouse_position()
			mouse_drag = true
	

func _input(event):
	if $"../..".map_open == true:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
					$SubViewport/level_render.camera.zoom.x += 0.1
					$SubViewport/level_render.camera.y += 0.1
			
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
					if $SubViewport/level_render.camera.zoom.x - 0.1 > 0.1:
						$SubViewport/level_render.camera.zoom.x -= 0.1
						$SubViewport/level_render.camera.zoom.y -= 0.1
			
		if event is InputEventMouseMotion:
			if mouse_drag:
				$SubViewport/level_render.camera.position = camera_start_pos + ((click_start_pos - get_global_mouse_position())*(1/$SubViewport/level_render.camera.zoom.x))
