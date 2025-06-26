extends Resource
class_name Sound

@export var volume: float = 1.0
@export var res_path: String = ""
@export var bus: String = "master"
@export var limit: int = -1
@export var minimum_time: float = 0
@export var max_distance: int = 1000

var sound: int = -1
var currently_playing: int = 0
var last_time_played_ms:int = 0

## set max hearing distance in pixels for 2d_player
func set_max_distance(_max_distance: int) -> Sound:
	max_distance = _max_distance
	return self

## path or uid to the resource of AudioStream type
func set_res_path(_res_path: String) -> Sound:
	res_path = _res_path
	return self

## sets player buss while playing this sound
func set_bus(_bus: String) -> Sound:
	bus = _bus
	return self

## sets maximum number of players playing this sound
func set_limit(_limit: int) -> Sound:
	limit = _limit
	return self

## sets volume in 1.0 = 100%
func set_volume(_volume: float) -> Sound:
	volume = _volume
	return self

## sets minimum delay this sound can be playd reducing cliping
func set_minimum_time(_minimum_time: float) -> Sound:
	minimum_time = _minimum_time
	return self

func is_at_play_limit() -> bool:
	if limit == -1:
		return false
	
	if currently_playing >= limit:
		return true
	
	return false

func is_valid_minimum_time() -> bool:
	return get_last_time_played_seconds() > minimum_time

func decrement_play_count() -> void:
	currently_playing -= 1

func update_last_time_played() -> void:
	last_time_played_ms = Time.get_ticks_msec()

func get_last_time_played_seconds() -> float:
	return (Time.get_ticks_msec() - last_time_played_ms) / 1000.0

var stream: AudioStream = null
