extends AudioPool
class_name SFXPlayer

var last_time_played: float = 0

func _init(pool_size: Array[int]) -> void:
	super._init(pool_size)
	
	print("Init : SFX Player")
	name = "SFXPlayer"

func _process(delta: float) -> void:
	last_time_played += delta
	_update_2d_players_position()
	
func _update_2d_players_position() -> void:
	for player in unavailable_player_array_2d:
		if player.playing:
			var following: Node2D = dic_player_related_2d[player]["following"]
			if following != null:
				player.global_position = following.global_position

#region 1D

func play(soundID: AudioDB.soundID) -> AudioStreamPlayer:
	var sound: Sound = AudioDB.sounds[soundID]
	if sound.is_at_play_limit():
		return
	
	if not sound.is_valid_minimum_time():
		return
	
	var player: AudioStreamPlayer = get_available_player()
	if player == null:
		return
	
	last_time_played = 0.0
	
	prepare_player(player, sound)
	
	player.call_deferred("play")
	return player

func play_stream(stream: AudioStream) -> AudioStreamPlayer:
	if stream == null:
		print("MusicPlayer : play_stream | no stream")
	
	var player: AudioStreamPlayer = get_available_player()
	player.stream = stream
	player.play()
	return player

#endregion

#region 2D

func play_2d(soundID: AudioDB.soundID, following: Node2D = null) -> AudioStreamPlayer2D:
	var sound: Sound = AudioDB.sounds[soundID]
	if sound.is_at_play_limit():
		return
	
	if not sound.is_valid_minimum_time():
		return
	
	var player: AudioStreamPlayer2D = get_available_player_2d()
	if player == null:
		return
	
	last_time_played = 0.0
	
	prepare_player_2d(player, sound, following)
	
	player.call_deferred("play")
	return player

func play_stream_2d(stream: AudioStream, following: Node2D = null) -> AudioStreamPlayer2D:
	if stream == null:
		print("MusicPlayer : play_stream | no stream")
	
	var player: AudioStreamPlayer2D = get_available_player_2d()
	player.stream = stream
	player.global_position = following.global_position
	player.call_deferred("play")
	return player

#endregion
