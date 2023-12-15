extends CanvasLayer

class_name Dialog

signal dialog_started(dialog_name)
signal dialog_ended(dialog_name)

@export var string_lable:Label
@export var who_lable:Label
@export var portret:TextureRect
@export var interact_button:Button

var current_dialog_name:String
var current_line:Dictionary
var current_dialog_line:int
var current_dialog_char_count:int
var playing:bool = false
var play_speed:float = 0.05
var time:float

var portrets = {
	"Player" : preload("res://assets/art/portrets/player_portret.png"),
	"Alarion" : preload("res://assets/art/portrets/alarion_portret.png"),
	"Thaladon" : preload("res://assets/art/portrets/thaladon_portret.png")
}

func _ready() -> void:
	hide()
	GameManager.dialog_box = self

func play(dialog_name:String) -> void:
	print("Dialog playing : " + dialog_name)
	
	$AnimationPlayer.play("Show")
	
	if GameManager.player != null:
		GameManager.player.paused = true
	
	current_dialog_name = dialog_name
	current_dialog_line = 0
	playing = true
	time = 0.0
	
	current_line = GameData.dialog_data[current_dialog_name]["dialogs"][0]
	
	string_lable.visible_characters = 0
	string_lable.text = current_line["string"]
	who_lable.text = current_line["who"]
	portret.texture = portrets[current_line["who"]]
	current_dialog_char_count = current_line["string"].length()
	interact_button.text = "> skip <"
	
	show()
	
	# Hide hud
	GameManager.hud.hide()
	
	emit_signal("dialog_started", current_dialog_name)

func _on_button_dialog_intearct_pressed() -> void:
	pass
	#_interact()

func _interact() -> void:
	match interact_button.text:
		"> skip <":
			_skip_dialog()
		"> continue <":
			_continue_dialog()
		"> end <":
			_close_dialog()

func _skip_dialog() -> void:
	string_lable.visible_characters = current_dialog_char_count

func _continue_dialog() -> void:
	interact_button.text = "> skip <"
	
	current_line = GameData.dialog_data[current_dialog_name]["dialogs"][current_dialog_line]
	string_lable.visible_characters = 0
	string_lable.text = current_line["string"]
	who_lable.text = current_line["who"]
	portret.texture = portrets[current_line["who"]]
	current_dialog_char_count = current_line["string"].length()
	interact_button.text = "> skip <"
	playing = true

func _on_dialong_ended() -> void:
	interact_button.text = "> continue <"
	
	current_dialog_line += 1
	if GameData.dialog_data[current_dialog_name]["dialogs"].size()-1 < current_dialog_line:
		interact_button.text = "> end <"

func _close_dialog() -> void:
	$AnimationPlayer.play("Hide")
	emit_signal("dialog_ended", current_dialog_name)
	
	if GameManager.player != null:
		GameManager.player.paused = false
	
	hide()
	GameManager.hud.show()
	GameData.data["dialog"][current_dialog_name] = true

func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 1:
			_interact()

func _process(delta) -> void:
	if playing:
		time += delta
		
		while time > play_speed:
			
			if string_lable.visible_characters == current_dialog_char_count:
				_on_dialong_ended()
				playing = false
			else:
				string_lable.visible_characters += 1
				if not $Audio.playing:
					$Audio.play()
				
			time -= play_speed
