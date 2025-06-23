extends Node2D

@export var id: int = 0

func _on_interactable_component_interacted() -> void:
	GameManager.dialog_box.play("table_" + str(id))

func  _ready() -> void:
	match GameManager.level_depth:
		1:
			id = 1
		3:
			id = 2
		5:
			id = 3
