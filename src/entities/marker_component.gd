extends Node2D
class_name EnemyMarker2D

@export var sprite:Sprite2D

func _physics_process(delta:float) -> void:
	var canvas:Transform2D = get_canvas_transform()
	var top_left:Vector2 = -canvas.origin / canvas.get_scale()
	var size:Vector2 = get_viewport_rect().size / canvas.get_scale()
	
	set_marker_position(Rect2(top_left,size))
	set_marker_rotation()

func set_marker_position(bounds:Rect2) -> void:
	sprite.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
	sprite.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()

func set_marker_rotation() -> void:
	var angle:float = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
