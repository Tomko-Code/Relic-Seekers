extends Node2D

@onready var HUD = get_node("HUD")

var loaded_zones = {}
var game_running = false
var current_zone: Zone = null

var player = null

func load_zone(zone_name:String, res_path:String):
	if loaded_zones.has(zone_name):
		print("game:load_zone | zone :" + zone_name + " is loaded.")
		return
	
	var zone_res = load(res_path)
	var zone = zone_res.instantiate()
	loaded_zones[zone.zone_name] = zone

func change_zone(zone_name:String, zone_spawn:int = 0):
	
	if current_zone != null:
		remove_child(current_zone)
		current_zone.remove_child(player)
		loaded_zones.erase(current_zone.zone_name)
		current_zone.queue_free()
	
	add_child(loaded_zones[zone_name])
	current_zone = loaded_zones[zone_name]
	
	current_zone.add_child(player)
	current_zone.on_zone_enter(zone_spawn)
	
	print("Zone change to : " + current_zone.zone_name)

func start_game():
	# load player
	player = load("res://src/entities/player/player_entity.tscn").instantiate()
	GameManager.player = player
	
	# load zone
	if GameData.data["prolg_complete"]:
		load_zone("zone_sanctuary_00", "res://src/zones/zone_sanctuary_00.tscn")
		change_zone("zone_sanctuary_00")
	else:
		# presuming first start of the game
		load_zone("zone_swamp_prolog_00", "res://src/zones/zone_swamp_prolog_00.tscn")
		load_zone("zone_sanctuary_00", "res://src/zones/zone_sanctuary_00.tscn")
		
		change_zone("zone_swamp_prolog_00")
	
	game_running = true

func _ready():
	pass

func _process(delta):
	pass
