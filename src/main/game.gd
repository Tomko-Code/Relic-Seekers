extends Node2D

@onready var HUD = get_node("HUD")

var loaded_zones = {}
var game_running = false
var current_zone = null

var player = null
var camera = null

func load_zone(zone_name:String, res_path:String):
	if loaded_zones.has(zone_name):
		print("game:load_zone | zone :" + zone_name + " is loaded.")
		return
	
	var zone_res = load(res_path)
	var zone = zone_res.instantiate()
	loaded_zones[zone.zone_name] = zone

func change_zone(zone_name:String):
	#await get_tree().process_frame
	
	if current_zone != null:
		remove_child(current_zone)
		loaded_zones.erase(current_zone.zone_name)
		current_zone.queue_free()
	
	add_child(loaded_zones[zone_name])
	current_zone = loaded_zones[zone_name]

func start_game():
	load_zone("mockup_zone_static_00", "res://src/zones/zone_swamp_prolog_00.tscn")
	change_zone("zone_swamp_prolog_00")
	game_running = true

func _ready():
	player = load("res://src/entities/player/player_entity.tscn").instantiate()
	add_child(player)

func _process(delta):
	pass
