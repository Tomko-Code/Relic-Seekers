extends Node2D

var direction: Vector2
var speed: float = 200
var is_returning: bool = false
var on_inpact_delete: bool = false
var boss

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("TileMap"):
		if on_inpact_delete:
			queue_free()
		else:
			on_inpact_delete = true
			direction = -direction
			rotation = direction.angle()
