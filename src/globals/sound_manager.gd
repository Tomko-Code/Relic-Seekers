extends Node

var sfx_sounds = {
	"shoot_sfx" = load("res://assets/audio/sfx/shoot_sfx.wav"),
	"death_sfx" = load("res://assets/audio/sfx/death_sfx.wav"),
	"hit_sfx" = load("res://assets/audio/sfx/hit_sfx.wav"),
	"gold_sfx" = load("res://assets/audio/sfx/gold_sfx.wav"),
	"mana_orb_sfx" = load("res://assets/audio/sfx/mana_orb_sfx.wav"),
	"emerald_sfx" = load("res://assets/audio/sfx/emerald_sfx.wav"),
	"heart_sfx" = load("res://assets/audio/sfx/heart_sfx.wav"),
	"pickup_sfx" = load("res://assets/audio/sfx/spell_arty_sfx.wav"),
}

var sound_streams = {}
var sfx_limit = 2
#var sfx_queue = []


func play_sfx(sfx_name):
	if sfx_sounds.has(sfx_name):
		var sfx_q = sound_streams.get(sfx_name, []) as Array
		sound_streams[sfx_name] = sfx_q
		
		if sfx_q.size() >= sfx_limit:
			var last_stream = sfx_q.pop_back() as AudioStreamPlayer
			if not last_stream.is_node_ready():
				sfx_q.push_front(last_stream)
				return
			last_stream.stop()
			last_stream.play()
		else:
			var audio_player = AudioStreamPlayer.new()
			audio_player.stream = sfx_sounds[sfx_name]
			audio_player.bus = "SFX"
			sfx_q.push_front(audio_player)
			call_deferred("add_child", audio_player)
			audio_player.call_deferred("play")
	
	#if sfx_sounds.has(sfx_name) and sfx_queue.size() < sfx_limit:
	#	var audio_player = AudioStreamPlayer.new()
	#	audio_player.stream = sfx_sounds[sfx_name]
	#	
	#	audio_player.bus = "SFX"
	#	audio_player.finished.connect(clear_sfx_object.bind(audio_player))
	#	audio_player.finished.connect(audio_player.queue_free)
	#	
	#	call_deferred("add_child", audio_player)
	#	audio_player.call_deferred("play")
	#	sfx_queue.append(audio_player)
		
#func clear_sfx_object(audio_player):
#	sfx_queue.erase(audio_player)
