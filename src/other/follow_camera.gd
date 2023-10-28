extends Node2D

@onready var Cursor = $Cursor

var speed = 3

var near_zone = 300
var far_zone = 400
var intermediate_zone = far_zone - near_zone

var draw_zones = true

var use_zones = true
var interpolate_distance_from_mouse = true


func initialize(_use_zones: bool = true, _interpolate_distance_from_mouse: bool = true,
			_speed = 3, _near_zone = 300, _far_zone = 400, _draw_debug = false):
	speed = _speed
	near_zone = _near_zone
	far_zone = _far_zone
	intermediate_zone = _far_zone - _near_zone
	
	draw_zones = _draw_debug
	Cursor.visible = _draw_debug
	
	use_zones = _use_zones
	interpolate_distance_from_mouse = _interpolate_distance_from_mouse


func _draw():
	if draw_zones:
		draw_arc(Vector2.ZERO, near_zone, PI*2, 0, 100, Color(1, 0, 0), 1)
		draw_arc(Vector2.ZERO, far_zone, PI*2, 0, 100, Color(0, 1, 0), 1)
		draw_arc(Vector2.ZERO, far_zone - near_zone, PI*2, 0, 100, Color(0, 0, 1), 1)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var screen_center = Vector2.ZERO
	
	if use_zones:
		var offset = mouse_pos - screen_center
		if offset.length() < near_zone:
			if interpolate_distance_from_mouse:
				Cursor.position = Cursor.position.lerp(screen_center, speed * delta)
			else:
				Cursor.position = screen_center
		else:
			if offset.length() > intermediate_zone:
				offset = offset.normalized() * intermediate_zone
			
			if interpolate_distance_from_mouse:
				Cursor.position = Cursor.position.lerp(screen_center + offset, speed * delta)
			else:
				Cursor.position = screen_center + offset
	else:
		Cursor.position = Vector2.ZERO
