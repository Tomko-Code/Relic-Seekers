extends Room


func _enter_tree() -> void:
	AudioManager.stop_music(1)

func _ready():
	GameManager.map.hide()
