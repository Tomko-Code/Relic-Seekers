extends Node2D

@export var connected_zone_res_path: String = ""
@export var connected_zone_name: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	await get_tree().process_frame
	GameManager.loaded_scenes["Game"].load_zone(connected_zone_name, connected_zone_res_path)
	GameManager.loaded_scenes["Game"].change_zone(connected_zone_name)
