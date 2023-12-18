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

var sfx_limit = 8
var sfx_queue = []

func play_sfx(sfx_name):
	if sfx_sounds.has(sfx_name) and sfx_queue.size() < sfx_limit:
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = sfx_sounds[sfx_name]
		
		audio_player.finished.connect(clear_sfx_object.bind(audio_player))
		audio_player.finished.connect(audio_player.queue_free)
		
		call_deferred("add_child", audio_player)
		audio_player.call_deferred("play")
		sfx_queue.append(audio_player)
		
func clear_sfx_object(audio_player):
	sfx_queue.erase(audio_player)
