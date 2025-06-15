extends Node

enum soundID {
	sfx_shoot,
	sfx_death,
	sfx_hit,
	sfx_gold,
	sfx_mana_orb,
	sfx_emerald,
	sfx_heart,
	sfx_pickup,
}

var sounds: Dictionary[soundID, Sound] = {
	soundID.sfx_shoot : Sound.new()
		.set_bus("SFX")
		.set_res_path("res://assets/audio/sfx/shoot_sfx.wav"),
		
	soundID.sfx_death : Sound.new()
		.set_bus("SFX")
		.set_res_path("res://assets/audio/sfx/death_sfx.wav"),
		
	soundID.sfx_hit : Sound.new()
		.set_bus("SFX")
		.set_res_path("res://assets/audio/sfx/hit_sfx.wav"),
		
	soundID.sfx_gold : Sound.new()
		.set_bus("SFX")
		.set_res_path("res://assets/audio/sfx/gold_sfx.wav")
		.set_limit(5)
		.set_minimum_time(0.1),
		
	soundID.sfx_mana_orb : Sound.new()
		.set_bus("SFX")
		.set_res_path("res://assets/audio/sfx/mana_orb_sfx.wav"),
		
	soundID.sfx_emerald : Sound.new()
		.set_bus("SFX")
		.set_res_path("res://assets/audio/sfx/emerald_sfx.wav")
		.set_limit(2)
		.set_minimum_time(0.1),
		
	soundID.sfx_heart : Sound.new()
		.set_bus("SFX")
		.set_res_path("res://assets/audio/sfx/heart_sfx.wav"),
		
	soundID.sfx_pickup : Sound.new()
		.set_bus("SFX")
		.set_res_path("res://assets/audio/sfx/spell_arty_sfx.wav"),
}

func _init() -> void:
	print("Init AudioDB")
	validate_sounds_settings()
	
	var mem: float = (OS.get_static_memory_usage()/1000.0)/1000.0
	load_all_sounds()
	
	print("= audio size : %.*f MiB" % [2, ((OS.get_static_memory_usage()/1000.0)/1000.0 - mem)])

func get_soundID(_name: String) -> soundID:
	if not soundID.has(_name):
		push_error(_name + " is not registred as a sound -> " + str(get_stack().back()))
		return 0
	
	return soundID.get(_name)

func validate_sounds_settings() -> void:
	print("AudioDB validator : not implemented !")

func load_all_sounds() -> void:
	for key in sounds:
		var sound:Sound = sounds[key]
		var stream:AudioStream = load(sound.res_path)
		sound.stream = stream
		print("+ load sound : " + sound.res_path)
