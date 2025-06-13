extends Node
class_name AudioPool

var available_player_array: Array[AudioStreamPlayer] = []
var available_player_array_2d: Array[AudioStreamPlayer2D] = []

var unavailable_player_array: Array[AudioStreamPlayer] = []
var unavailable_player_array_2d: Array[AudioStreamPlayer2D] = []

var dic_player_related: Dictionary[AudioStreamPlayer, Dictionary] = {}
var dic_player_related_2d: Dictionary[AudioStreamPlayer2D, Dictionary] = {}

func _init(pool_size: Array[int]) -> void:
	if pool_size.is_empty():
		print("invalid pool size : 0")
		return
	
	else:
		_resize_player_array(pool_size[0])
	
	if pool_size.size() > 1:
		_resize_player_array_2d(pool_size[1])

#region 1D Player

func get_players_streaming_resource(stream: AudioStream) -> Array[AudioStreamPlayer]:
	var streams: Array[AudioStreamPlayer] = []
	for player in unavailable_player_array:
		if player.stream == stream:
			streams.append(player)
	
	return streams

func get_player_playing(sound: Sound) -> AudioStreamPlayer:
	for player in unavailable_player_array:
		if player.playing:
			if dic_player_related[player]["sound"] == sound:
				return player
	
	return null

func add_fade_in(player: AudioStreamPlayer, time: float) -> void:
	kill_player_tween(player)
	
	var tween_fade_in:Tween = create_tween()
	tween_fade_in.set_ease(Tween.EASE_IN)
	tween_fade_in.set_trans(Tween.TRANS_QUINT)
	var volume = 1.0
	if dic_player_related[player]["sound"] != null:
		volume = dic_player_related[player]["sound"].volume
	
	tween_fade_in.tween_property(player, "volume_linear", volume, time)
	
	dic_player_related[player]["tween"] = tween_fade_in

func add_fade_out(player: AudioStreamPlayer, time: float) -> void:
	kill_player_tween(player)
	
	var tween_fade_in:Tween = create_tween()
	tween_fade_in.set_ease(Tween.EASE_OUT)
	tween_fade_in.set_trans(Tween.TRANS_QUINT)
	tween_fade_in.tween_property(player, "volume_linear", 0.0, time)
	tween_fade_in.tween_callback(set_player_to_avaiable.bind(player))
	
	dic_player_related[player]["tween"] = tween_fade_in

func kill_player_tween(player: AudioStreamPlayer) -> void:
	if dic_player_related[player]["tween"] != null:
		dic_player_related[player]["tween"].kill()

func resume_player(player: AudioStreamPlayer):
	player.stream_paused = false
	var tween:Tween = dic_player_related[player]["tween"]
	if tween != null:
		if tween.is_valid():
			tween.play()

func resume_all_players() -> void:
	for player in unavailable_player_array:
		if not player.playing:
			resume_player(player)

func stop_all_players() -> void:
	for player in unavailable_player_array:
		if player.playing:
			stop_player(player)

func fade_out_all_players(time: float) -> void:
	for player in unavailable_player_array:
		if player.playing:
			add_fade_out(player, time)

func pause_player(player: AudioStreamPlayer) -> void:
	player.stream_paused = true
	var tween:Tween = dic_player_related[player]["tween"]
	if tween != null:
		if tween.is_valid():
			tween.pause()

func pause_all_players() -> void:
	for player in unavailable_player_array:
		if player.playing:
			pause_player(player)

func stop_player(player: AudioStreamPlayer) -> void:
	player.stop()
	player.finished.emit()

func set_player_to_default(player: AudioStreamPlayer):
	player.volume_db = 1.0

func prepare_player(player: AudioStreamPlayer, sound: Sound) -> void:
	player.volume_db = sound.volume
	player.stream = sound.stream
	player.bus = sound.bus
	
	dic_player_related[player]["sound"] = sound

	sound.currently_playing += 1
	sound.update_last_time_played()
	
	player.connect("finished", set_player_to_avaiable.bind(player))

func set_player_to_avaiable(player: AudioStreamPlayer) -> void:
	if player == null:
		print("Error player is null at set : " + str(get_stack()))
	
	var pos:int = unavailable_player_array.find(player)
	available_player_array.push_front(unavailable_player_array[pos])
	unavailable_player_array.remove_at(pos)
	
	if dic_player_related[player]["sound"] != null:
		dic_player_related[player]["sound"].decrement_play_count()
	
	dic_player_related[player]["sound"] = null
	
	kill_player_tween(player)
	
	for con in player.finished.get_connections():
		player.disconnect("finished", con["callable"])

## 0 - will not crate player over reaching limit [br]
## 1 - will crate new player on reaching limit
func get_available_player(importance:int = 0) -> AudioStreamPlayer:
	if available_player_array.size() == 0:
		if importance == 0:
			return null
		else:
			_add_player()
	
	return _set_player_to_unavaiable(available_player_array.pop_back())

func _set_player_to_unavaiable(player: AudioStreamPlayer) -> AudioStreamPlayer:
	unavailable_player_array.append(player)
	return player

func _add_player() -> AudioStreamPlayer:
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(player)
	dic_player_related.set(player, {"tween" : null, "sound" : null})
	available_player_array.append(player)
	return player

func _resize_player_array(size: int) -> void:
	for i in range(size):
		_add_player()

#endregion

#region 2D Player

func get_players_streaming_resource_2d(stream: AudioStream) -> Array[AudioStreamPlayer2D]:
	var streams: Array[AudioStreamPlayer2D] = []
	for player in unavailable_player_array_2d:
		if player.stream == stream:
			streams.append(player)
	
	return streams

func get_player_playing_2d(sound: Sound) -> AudioStreamPlayer2D:
	for player in unavailable_player_array_2d:
		if player.playing:
			if dic_player_related_2d[player]["sound"] == sound:
				return player
	
	return null

func add_fade_in_2d(player: AudioStreamPlayer2D, time: float) -> void:
	kill_player_tween_2d(player)
	
	var tween_fade_in:Tween = create_tween()
	tween_fade_in.set_ease(Tween.EASE_IN)
	tween_fade_in.set_trans(Tween.TRANS_QUINT)
	
	var volume = 1.0
	if dic_player_related_2d[player]["sound"] != null:
		volume = dic_player_related_2d[player]["sound"].volume
	
	tween_fade_in.tween_property(player, "volume_linear", volume, time)
	
	dic_player_related_2d[player]["tween"] = tween_fade_in

func add_fade_out_2d(player: AudioStreamPlayer2D, time: float) -> void:
	kill_player_tween_2d(player)
	
	var tween_fade_in:Tween = create_tween()
	tween_fade_in.set_ease(Tween.EASE_OUT)
	tween_fade_in.set_trans(Tween.TRANS_QUINT)
	tween_fade_in.tween_property(player, "volume_linear", 0.0, time)
	tween_fade_in.tween_callback(set_player_to_avaiable.bind(player))
	
	dic_player_related_2d[player]["tween"] = tween_fade_in

func kill_player_tween_2d(player: AudioStreamPlayer2D) -> void:
	if dic_player_related_2d[player]["tween"] != null:
		dic_player_related_2d[player]["tween"].kill()

func resume_player_2d(player: AudioStreamPlayer2D):
	player.stream_paused = false
	var tween:Tween = dic_player_related_2d[player]["tween"]
	if tween != null:
		if tween.is_valid():
			tween.play()

func resume_all_players_2d() -> void:
	for player in unavailable_player_array_2d:
		if not player.playing:
			resume_player_2d(player)

func stop_all_players_2d() -> void:
	for player in unavailable_player_array_2d:
		if player.playing:
			stop_player_2d(player)

func fade_out_all_players_2d(time: float) -> void:
	for player in unavailable_player_array_2d:
		if player.playing:
			add_fade_out_2d(player, time)

func pause_player_2d(player: AudioStreamPlayer2D) -> void:
	player.stream_paused = true
	var tween:Tween = dic_player_related_2d[player]["tween"]
	if tween != null:
		if tween.is_valid():
			tween.pause()

func pause_all_players_2d() -> void:
	for player in unavailable_player_array_2d:
		if player.playing:
			pause_player_2d(player)

func stop_player_2d(player: AudioStreamPlayer2D) -> void:
	player.stop()
	player.finished.emit()

func set_player_to_default_2d(player: AudioStreamPlayer2D):
	player.volume_db = 1.0

func prepare_player_2d(player: AudioStreamPlayer2D, sound: Sound, following: Node2D) -> void:
	player.volume_db = sound.volume
	player.stream = sound.stream
	player.bus = sound.bus
	player.max_distance = sound.max_distance
	
	dic_player_related_2d[player]["sound"] = sound
	dic_player_related_2d[player]["following"] = following
	
	sound.currently_playing += 1
	sound.update_last_time_played()
	
	player.connect("finished", set_player_to_avaiable_2d.bind(player))

func set_player_to_avaiable_2d(player: AudioStreamPlayer2D) -> void:
	if player == null:
		print("Error player is null at set : " + str(get_stack()))
	
	var pos:int = unavailable_player_array_2d.find(player)
	available_player_array_2d.push_front(unavailable_player_array_2d[pos])
	unavailable_player_array_2d.remove_at(pos)
	
	if dic_player_related_2d[player]["sound"] != null:
		dic_player_related_2d[player]["sound"].decrement_play_count()
	
	dic_player_related_2d[player]["sound"] = null
	dic_player_related_2d[player]["following"] = null
	
	kill_player_tween_2d(player)
	
	for con in player.finished.get_connections():
		player.disconnect("finished", con["callable"])

## 0 - will not crate player over reaching limit [br]
## 1 - will crate new player on reaching limit
func get_available_player_2d(importance:int = 0) -> AudioStreamPlayer2D:
	if available_player_array_2d.size() == 0:
		if importance == 0:
			return null
		else:
			_add_player_2d()
	
	return _set_player_to_unavaiable_2d(available_player_array_2d.pop_back())

func _set_player_to_unavaiable_2d(player: AudioStreamPlayer2D) -> AudioStreamPlayer2D:
	unavailable_player_array_2d.append(player)
	return player

func _add_player_2d() -> AudioStreamPlayer2D:
	var player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	add_child(player)
	dic_player_related_2d.set(player, {"tween" : null, "sound" : null, "following" : null})
	available_player_array_2d.append(player)
	return player

func _resize_player_array_2d(size: int) -> void:
	for i in range(size):
		_add_player_2d()

func update_players_2d_position() -> void:
	for player in unavailable_player_array_2d:
		var following: Node2D = dic_player_related_2d[player]["following"]
		if following != null:
			player.global_position = following.global_position

#endregion
