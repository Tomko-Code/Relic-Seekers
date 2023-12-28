extends SubViewportContainer


var camera_start_pos:Vector2 = Vector2.ZERO 
var click_start_pos:Vector2 = Vector2.ZERO 
var mouse_drag:bool = false

func _process(delta):
	if Input.is_action_just_released("LMB_pressed"):
		mouse_drag = false
		
	if Input.is_action_just_pressed("LMB_pressed"):
		camera_start_pos = $RoomView/Camera2D.position
		click_start_pos = get_global_mouse_position()
		mouse_drag = true
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
				$RoomView/Camera2D.zoom.x += 0.1
				$RoomView/Camera2D.zoom.y += 0.1
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
				$RoomView/Camera2D.zoom.x -= 0.1
				$RoomView/Camera2D.zoom.y -= 0.1
		
	if event is InputEventMouseMotion:
		if mouse_drag:
			$RoomView/Camera2D.position = camera_start_pos + ((click_start_pos - get_global_mouse_position())*(1/$RoomView/Camera2D.zoom.x))
