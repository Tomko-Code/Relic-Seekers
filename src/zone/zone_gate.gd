extends Node2D

@export var connected_zone_res_path: String = ""
@export var connected_zone_name: String = ""
@export var id: int

func _on_body_entered(body):
	await get_tree().process_frame
	GameManager.loaded_scenes["Game"].load_zone(connected_zone_name, connected_zone_res_path)
	GameManager.loaded_scenes["Game"].change_zone(connected_zone_name)
