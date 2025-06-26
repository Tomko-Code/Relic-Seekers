class_name PlayerEntity
extends CharacterBody2D

@export var _UserMovementComponent: UserMovementComponent
@warning_ignore("unused_private_class_variable")
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent
@export var _PlayerStatsComponent: PlayerStatsComponent

@export var pit_hit_box:Area2D
var pit_count:int = 0

var last_safe_cord: Vector2

var paused:bool = false
var draw_position:bool = false

signal death
@warning_ignore("unused_signal")
signal health_changed

func _ready():
	var use_zones = true
	var interpolate_camera_position = true
	var camera_speed = 1
	var near_zone = 100
	var far_zone = 200
	var inner_zone = 50
	var debug_display = false
	
	GameManager.attach_camera_to_node(self, use_zones, 
		interpolate_camera_position, camera_speed, near_zone, far_zone, 
		inner_zone, debug_display)
	
	_UserMovementComponent.dash_over.connect(on_dash_over)

func _physics_process(_delta):
	
	var game: Game = GameManager.loaded_scenes["Game"]
	var room: Room = game.active_level.currnet_active_room
	if room != null:
		var cord: Vector2 = (($PitHitBox.global_position - room.global_position)/Constants.FLOOR_TILE_SIZE).floor()
	
		if game.level_state != game.LEVEL_STATES.SANCTUARY and room.name != "SwampRoom":
			if room.is_this_spot_free(cord) and cord != last_safe_cord:
				last_safe_cord = cord
	
	queue_redraw()

func on_player_enter_room(room: Room) -> void:
	print(room.name)
	
	GameManager.game_camera.limit = true
	
	if room.name != "SanctuaryRoom":
		@warning_ignore("narrowing_conversion")
		@warning_ignore("integer_division")
		GameManager.game_camera.new_limit_left = room.global_position.x + (640/2)
		@warning_ignore("integer_division")
		@warning_ignore("narrowing_conversion")
		GameManager.game_camera.new_limit_top = room.global_position.y + (360/2)
		@warning_ignore("integer_division")
		@warning_ignore("narrowing_conversion")
		GameManager.game_camera.new_limit_right = room.global_position.x + (room.data.get_room_size().x * Constants.CHUNK_SIZE.x) - (640/2)
		@warning_ignore("integer_division")
		@warning_ignore("narrowing_conversion")
		GameManager.game_camera.new_limit_bottom = room.global_position.y + (room.data.get_room_size().y * Constants.CHUNK_SIZE.y) - (360/2)
	
		if room.name == "StartRoom":
			GameManager.game_camera.limit_left =  GameManager.game_camera.new_limit_left
			GameManager.game_camera.limit_right =  GameManager.game_camera.new_limit_right
			GameManager.game_camera.limit_bottom =  GameManager.game_camera.new_limit_bottom
			GameManager.game_camera.limit_top =  GameManager.game_camera.new_limit_top
	
	if room.name == "SwampRoom":
		GameManager.game_camera.limit = false

func _on_pit_hit_box_body_entered(_body:TileMap):
	pit_count += 1
	if not _UserMovementComponent.is_dashing:
		fall(pit_hit_box.global_position)
		

func on_dash_over():
	if not _UserMovementComponent.is_dashing and pit_count > 0:
		fall(_UserMovementComponent.das_start_pos)

func fall(_pos:Vector2) -> void:
	$AnimationPlayer.play("fall")
	paused = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fall":
		var game: Game = GameManager.loaded_scenes["Game"]
		var room: Room = game.active_level.currnet_active_room
		$PitHitBox/AudioPitFall.play()
		$AnimationPlayer.play("RESET")
		pit_count = 0
		velocity = Vector2.ZERO
		paused = false
		_PlayerStatsComponent.change_health(1)
		global_position = room.global_position + (last_safe_cord * Constants.FLOOR_TILE_SIZE) + (Constants.FLOOR_TILE_SIZE/2) - $PitHitBox.position


func _draw():
	if draw_position:
		var cord = (pit_hit_box.global_position/Constants.FLOOR_TILE_SIZE).floor()
		draw_rect(Rect2(cord*Constants.FLOOR_TILE_SIZE-global_position,Constants.FLOOR_TILE_SIZE), Color(1, 1, 0.27843138575554), false, 2)

func _on_pit_hit_box_body_exited(_body):
	pit_count -= 1
	pit_count = clamp(pit_count, 0, INF)
	
func call_death():
	emit_signal("death")

func _on_health_changed():
	#GameData.save_file.current_health = _PlayerStatsComponent.current_health
	pass
