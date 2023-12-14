class_name PlayerEntity
extends CharacterBody2D

@export var _UserMovementComponent: UserMovementComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent
@export var _PlayerStatsComponent: PlayerStatsComponent

@export var pit_hit_box:Area2D
var pit_count:int = 0

var paused:bool = false
var draw_position:bool = true

signal death
signal health_changed

func _ready():
	var use_zones = true
	var interpolate_camera_position = true
	var camera_speed = 1
	var near_zone = 300
	var far_zone = 400
	var inner_zone = 50
	var debug_display = false
	
	GameData.save_file.player_inventory
	
	GameManager.attach_camera_to_node(self, use_zones, 
		interpolate_camera_position, camera_speed, near_zone, far_zone, 
		inner_zone, debug_display)
	
	_UserMovementComponent.dash_over.connect(on_dash_over)

func _physics_process(_delta):
	queue_redraw()

func _on_pit_hit_box_body_entered(body:TileMap):
	pit_count += 1
	if not _UserMovementComponent.is_dashing:
		fall(pit_hit_box.global_position)

func on_dash_over():
	if not _UserMovementComponent.is_dashing and pit_count > 0:
		fall(_UserMovementComponent.das_start_pos)

func fall(pos:Vector2) -> void:
	var game = GameManager.loaded_scenes["Game"]
	var level:Level = game.active_level
	var cord = level.currnet_active_room.look_for_open_space(pos)
	
	$PitHitBox/AudioPitFall.play()
	
	_PlayerStatsComponent.change_health(1)
	global_position = (cord * Constants.FLOOR_TILE_SIZE) + (Constants.FLOOR_TILE_SIZE/2)

func _draw():
	if draw_position:
		var cord = (pit_hit_box.global_position/Constants.FLOOR_TILE_SIZE).floor()
		draw_rect(Rect2(cord*Constants.FLOOR_TILE_SIZE-global_position,Constants.FLOOR_TILE_SIZE), Color(1, 1, 0.27843138575554), false, 2)

func _on_pit_hit_box_body_exited(body):
	pit_count -= 1
	
func call_death():
	emit_signal("death")

func _on_health_changed():
	#GameData.save_file.current_health = _PlayerStatsComponent.current_health
	pass
