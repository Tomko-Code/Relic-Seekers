extends AudioPool
class_name MusicPlayer

var paused: bool = false

func _init(pool_size:Array[int]) -> void:
	super._init(pool_size)
	
	print("Init : Music Player")
	name = "MusicPlayer"

func stop(fade_out: float):
	fade_out_all_players(fade_out)

func pause():
	pause_all_players()
	paused = true

func resume():
	resume_all_players()
	paused = false

func play(soundID: AudioDB.soundID, fade_in: float, fade_out: float) -> AudioStreamPlayer:
	if paused == true:
		return
	
	var sound: Sound = AudioDB.sounds[soundID]
	if sound.is_at_play_limit():
		var player_playing: AudioStreamPlayer = get_player_playing(sound)
		if player_playing == null:
			return

		fade_out_all_players(fade_out)
		add_fade_in(player_playing, fade_in)
		return
	
	var player: AudioStreamPlayer = get_available_player(1)

	fade_out_all_players(fade_out)
	prepare_player(player, sound)
	
	player.volume_linear = 0.0
	add_fade_in(player, fade_in)
	
	player.call_deferred("play")
	return player


func play_stream(stream: AudioStream, bus: String, fade_in: float, fade_out: float) -> void:
	if paused == true:
		return
	
	if stream == null:
		print("MusicPlayer : play_stream | no stream")
	
	var players: Array[AudioStreamPlayer] = get_players_streaming_resource(stream)
	var player: AudioStreamPlayer
	
	for p in players:
		if dic_player_related[p]["sound"] == null:
			player = players[0]
			fade_out_all_players(fade_out)
			add_fade_in(player, fade_in)
			return
		
	if player == null:
		player = get_available_player(1)
		set_player_to_default(player)
		player.volume_linear = 0.0
	
	fade_out_all_players(fade_out)
	add_fade_in(player, fade_in)
	
	player.stream = stream
	player.bus = bus
	player.call_deferred("play")
