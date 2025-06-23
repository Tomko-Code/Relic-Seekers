extends Node2D
class_name ActivatedPilar

@export var pilar_id: int = 0

var active: bool = false:
	set(value):
		active = value
		
		if active:
			$AnimatedSprite2D.play("set_on")
			$Conponents/InteractableComponent.interaction_title = "Deactivate"
		else:
			$AnimatedSprite2D.play("set_off")
			$Conponents/InteractableComponent.interaction_title = "Activate"

func _ready() -> void:
	match GameManager.level_depth:
		1:
			pilar_id = 1
		3:
			pilar_id = 2
		5:
			pilar_id = 3
	
	active = GameData.save_file.secret_pilar_array_id[pilar_id]
	
	GameData.save_file.secret_pilar_set.connect(_on_pilar_set)

func _on_pilar_set(id: int, value: bool):
	if id == pilar_id:
		active = value

func _on_interactable_component_interacted() -> void:
	$AudioStreamPlayer.play()
	GameData.save_file.set_pilar(pilar_id, !active)
