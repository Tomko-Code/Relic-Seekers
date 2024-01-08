extends CanvasLayer
class_name HUD

@export var fps_lable:Label

func _ready():
	GameManager.hud = self
	
	fps_lable.visible = Settings.get_setting("show_fps")
	Settings.setting_changed.connect(on_settings_changed)

func _process(delta):
	if fps_lable.visible:
		fps_lable.text = "FPS : " + str(Engine.get_frames_per_second())


func on_settings_changed(setting:String, value) -> void:
	match setting:
		"show_fps":
			fps_lable.visible = value
