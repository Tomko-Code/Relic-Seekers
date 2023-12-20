extends Node2D
class_name Game

signal level_change(level:Level)

@onready var HUD = get_node("HUD")

var game_running:bool = false

enum LEVEL_STATES { NULL, CURRENT, SANCTUARY}
var level_state:LEVEL_STATES = LEVEL_STATES.NULL

var sanctuary_level:SanctuaryLevel = null
var current_level:Level = null

var active_level:Level = null

var player:PlayerEntity = null

var type = PlayerEntity

func on_player_death():

	GameData.save_file.player_inventory.reset()
	GameData.save_file.max_health = 6
	GameData.save_file.current_health = GameData.save_file.max_health
	
	GameManager.player._PlayerStatsComponent.max_health = GameData.save_file.max_health
	GameManager.player._PlayerStatsComponent.current_health = GameData.save_file.max_health
	GameManager.player.emit_signal("health_changed")

	call_deferred("change_active_to_sanctuary_level")
	$Map/CenterContainer/SubViewportContainer/SubViewport/level_render.clear_render()

func change_current_level(level:Level) -> void:
	# Check if level is alrady active
	if current_level == level:
		print("Level is already active : " + current_level.name)
		return
	
	# Remove current level
	if current_level != null:
		clear_level(current_level)
	
	current_level = level
	emit_signal("level_change", level)
	
	print("Current level change to : " + level.name)

func clear_level(level:Level) -> void:
	if level_state == LEVEL_STATES.CURRENT:
		deactivate_level(level)
	
	level.queue_free()

func deactivate_level(level:Level) -> void:
	remove_child(level)
	level.remove_child(player)

func activate_level(level:Level) -> void:
	add_child(level)
	level.add_child(player)
	level.emit_signal("level_activated")
	
	active_level = level

func change_active_to_current_level() -> void:
	$Map.show()
	
	if level_state == LEVEL_STATES.SANCTUARY:
		deactivate_level(sanctuary_level)
	
	activate_level(current_level)
	
	level_state = LEVEL_STATES.CURRENT

func change_active_to_sanctuary_level() -> void:
	$Map.hide()
	
	if level_state == LEVEL_STATES.CURRENT:
		deactivate_level(current_level)

	activate_level(sanctuary_level)
	
	# TODO : replace this to sanctuary room
	player.position = Vector2(-160, 480)
	# ######################
	
	level_state = LEVEL_STATES.SANCTUARY

func start_game(start_option:Constants.STARTING_OPTIONS) -> void:
	game_running = true
	
	print("Game starts in mode : " + str(start_option))
	print("Player load.")
	load_player()
	
	match start_option:
		Constants.STARTING_OPTIONS.NORMAL:
			normal_start()
		Constants.STARTING_OPTIONS.COMBAT:
			combat_start()

func load_player() -> void:
	player = load("res://src/entities/player/player_entity.tscn").instantiate()
	player.death.connect(on_player_death)
	GameManager.player = player

func combat_start() -> void:
	load_sanctuary()
	
	var level:CombatLevel = CombatLevel.new()
	level.set_up()
	change_current_level(level)
	change_active_to_current_level()

func normal_start() -> void:
	load_sanctuary()
	
	if GameData.save_file.prolog_complete:
		change_active_to_sanctuary_level()
	else:
		var level:StartLevel = StartLevel.new()
		level.set_up()
		change_current_level(level)
		change_active_to_current_level()

func load_sanctuary():
	sanctuary_level = SanctuaryLevel.new()
	sanctuary_level.set_up()

func _ready():
	pass

func _process(delta):
	pass
