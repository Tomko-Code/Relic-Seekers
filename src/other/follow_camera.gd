extends Node2D

#TODO: support multiple zones, with different, inner/far_near zones

@onready var Cursor = $CursorLayer/Cursor
@onready var Camera = $Camera2D

var speed = 30

var near_zone = 300
var far_zone = 400
var inner_zone = 100

var intermediate_zone = far_zone - near_zone

var draw_zones = true

var use_zones = true
var interpolate_distance_from_mouse = true


var last_offset = Vector2.ZERO

func initialize(_use_zones: bool = true, _interpolate_distance_from_mouse: bool = true,
			_speed = 3, _near_zone = 300, _far_zone = 400, _inner_zone = 0, _draw_debug = false):
	speed = _speed
	near_zone = _near_zone
	far_zone = _far_zone
	intermediate_zone = _far_zone - _near_zone
	if _inner_zone == 0:
		inner_zone = intermediate_zone
	else:
		inner_zone = _inner_zone
	
	draw_zones = _draw_debug
	Cursor.visible = _draw_debug
	
	use_zones = _use_zones
	interpolate_distance_from_mouse = _interpolate_distance_from_mouse
	
	$CursorLayer/Cursor.position = get_viewport_rect().size / 2


func _draw():
	if draw_zones:
		print(last_offset)
		draw_arc(last_offset, near_zone, PI*2, 0, 100, Color(1, 0, 0), 1)
		draw_arc(last_offset, far_zone, PI*2, 0, 100, Color(0, 1, 0), 1)
		draw_arc(Vector2.ZERO, intermediate_zone, PI*2, 0, 100, Color(0, 0, 1), 1)
		draw_arc(Vector2.ZERO, inner_zone, PI*2, 0, 100, Color(0, 0, 1), 1)
		draw_line(Camera.position, last_offset, Color(1,1,0), 1)

func _process(delta):
	var mouse_pos = Cursor.get_global_mouse_position()
	var screen_center = get_viewport_rect().size / 2
	
	if use_zones:
		var offset = mouse_pos - screen_center
		
		offset = offset.normalized() * max(0, offset.length() - near_zone)
		print((offset.length() / intermediate_zone))
		offset = offset.normalized() * (offset.length() / intermediate_zone) * inner_zone
		
		
		
		if offset.length() < 1:
			if interpolate_distance_from_mouse:
				Cursor.position = Cursor.position.lerp(screen_center, speed * delta)
				Camera.position = Camera.position.lerp(Vector2.ZERO, speed * delta)
				
			else:
				Cursor.position = screen_center
				Camera.position = Vector2.ZERO
		else:
			if offset.length() > inner_zone:
				#offset = offset.normalized() * intermediate_zone 
				offset = offset.normalized() * inner_zone 
			if interpolate_distance_from_mouse:
				Cursor.position = Cursor.position.lerp(screen_center + offset, speed * delta)
				Camera.position = Camera.position.lerp(Vector2.ZERO + offset, speed * delta)
			else:
				Cursor.position = screen_center + offset
				Camera.position = Vector2.ZERO + offset
		last_offset = offset
		if draw_zones:
			queue_redraw()
	else:
		Cursor.position = screen_center
		Camera.position = Vector2.ZERO
