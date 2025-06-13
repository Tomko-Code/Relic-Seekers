extends Node
#############
# AudioManager
#############

var music_player: MusicPlayer
var sfx_player: SFXPlayer
var ui_player
var ambient_player:CanvasItem

func _init() -> void:
	print("Init : Audio Manager")
	music_player = MusicPlayer.new([2])
	sfx_player = SFXPlayer.new([48,16])
	
	add_child(music_player)
	add_child(sfx_player)

func _ready() -> void:
	pass


#region sfx

func play_sfx(sound:AudioDB.soundID) -> AudioStreamPlayer:
	return sfx_player.play(sound)

func play_sfx_2d(sound:AudioDB.soundID, following: Node2D = null) -> AudioStreamPlayer2D:
	return sfx_player.play_2d(sound, following)

#endregion

#region music

func play_music_stream(stream: AudioStream, bus: String, fade_in: float = 0.0, fade_out: float = 0.0) -> void:
	music_player.play_stream(stream, bus, fade_in, fade_out)

func play_music(soundID: AudioDB.soundID, fade_in: float = 0.0, fade_out: float = 0.0) -> AudioStreamPlayer:
	return music_player.play(soundID, fade_in, fade_out)

func stop_music(fade_out: float = 0) -> void:
	music_player.stop(fade_out)

func resume_music() -> void:
	music_player.resume()

func pause_music() -> void:
	music_player.pause()

#endregion
