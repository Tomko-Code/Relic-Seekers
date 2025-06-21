class_name FollowCamera
extends Node2D

#TODO: support multiple zones, with different, inner/far_near zones

@onready var Cursor = $CursorLayer/Cursor
@onready var Camera = $Camera2D

var speed = 25

var near_zone = 150
var far_zone = 200
var inner_zone = 5

var limit: bool = true

var intermediate_zone = far_zone - near_zone

var draw_zones = true

var use_zones = true
var interpolate_distance_from_mouse = true

var limit_left:float = 0
var limit_top:float = 0
var limit_right:float = 1000000
var limit_bottom:float = 1000000

var new_limit_left:float = 0
var new_limit_top:float = 0
var new_limit_right:float = 1000000
var new_limit_bottom:float = 1000000

var last_offset = Vector2.ZERO

func initialize(_use_zones: bool = true, _interpolate_distance_from_mouse: bool = true,
			_speed = 3, _near_zone = 150, _far_zone = 200, _inner_zone = 0, _draw_debug = true):
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
		draw_arc(last_offset, near_zone, PI*2, 0, 100, Color(1, 0, 0), 1)
		draw_arc(last_offset, far_zone, PI*2, 0, 100, Color(0, 1, 0), 1)
		draw_arc(Vector2.ZERO, intermediate_zone, PI*2, 0, 100, Color(0, 0, 1), 1)
		draw_arc(Vector2.ZERO, inner_zone, PI*2, 0, 100, Color(0, 0, 1), 1)
		draw_line(Camera.position, last_offset, Color(1,1,0), 1)

var frozen_position: Vector2 = Vector2.ZERO

func freeze_position():
	frozen_position = get_parent().global_position + position

func unfreeze_position():
	global_position = frozen_position
	frozen_position = Vector2.ZERO

func play_slow():
	#$AnimationPlayer.play("SlowCameraEffect")
	#print("play")
	pass

func _process(delta):
	var mouse_pos = Cursor.get_global_mouse_position()
	var screen_center = get_viewport_rect().size / 2
	#print(screen_center)
	#print(get_local_mouse_position())
	#print(Cursor.get_local_mouse_position())
	#if Cursor.get_local_mouse_position().y > screen_center.y:
	#	mouse_pos.y -= 0.3 * (Cursor.get_local_mouse_position().y - screen_center.y)
	#else:
	#	mouse_pos.y -= 0.3 * (Cursor.get_local_mouse_position().y - screen_center.y)
	
	position = position.lerp(Vector2.ZERO, speed * 2 * delta)
	if limit:
		limit_left = lerp(limit_left, new_limit_left, speed * 2.0 * delta)
		limit_right = lerp(limit_right, new_limit_right, speed * 2.0 * delta)
		limit_top = lerp(limit_top, new_limit_top, speed * 2.0 * delta)
		limit_bottom = lerp(limit_bottom, new_limit_bottom, speed * 2.0 * delta)
	
	if use_zones:
		#mouse_pos.y *= 1.7
		var offset = mouse_pos - screen_center
		offset.y *= 1.7
		
		offset = offset.normalized() * max(0, offset.length() - near_zone)
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
				#print(offset)
				#print(inner_zone)
				offset = offset.normalized() * inner_zone * Vector2(2.5, 2.5)
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
	
	if limit:
		Camera.global_position.x = clamp(Camera.global_position.x, limit_left, limit_right)
		Camera.global_position.y = clamp(Camera.global_position.y, limit_top, limit_bottom)
