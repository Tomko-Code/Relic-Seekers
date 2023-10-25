extends Node2D
var zone_data = load("res://src/zone/zone.tscn")
var child = null

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	var instance = zone_data.instantiate()
	var floor = instance.get_node("Floor") as Sprite2D
	floor.position = Vector2(randi_range(0,600),randi_range(0,600))
	floor.scale = Vector2(randf_range(1.0, 3.0), randf_range(1.0, 3.0))
	
	if child != null:
		remove_child(child)
		child.queue_free()
	
	add_child(instance)
	
	child = instance
