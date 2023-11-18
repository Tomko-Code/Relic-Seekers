extends Node2D

signal interacted

@export var active: bool = true
@export var interaction_input:InputEvent
@export var input_text:String = ""
@export var interaction_descryption:String = ""
@export var offset:Vector2i = Vector2i.ZERO

var _in_range:bool = false
var player:PlayerEntity = null
var group_name:String

func _ready() -> void:
	$HBoxContainer.visible = false
	$HBoxContainer.position = offset
	
	$HBoxContainer/Descryption.text = interaction_descryption
	$HBoxContainer/Input.text = "(" + input_text + ")"
	
	group_name = "interactable_" + String.chr(interaction_input.keycode)

func _input(event) -> void:
	if event is InputEventKey:
		var just_pressed = event.is_pressed() and not event.is_echo()
		if event.is_match(interaction_input) and just_pressed:
			if active and _in_range and is_closest_iteraction():
				emit_signal("interacted")
				$AnimationInput.play("Interacted")

func get_distance_to_player() -> int:
	
	return global_position.distance_to(player.global_position)

# returns if interactable is closer then any other interactable
func is_closest_iteraction() -> bool:
	var distance_to_player:float = get_distance_to_player()
	
	for interactable in get_tree().get_nodes_in_group(group_name):
		if interactable != self:
			if distance_to_player > interactable.get_distance_to_player():
				return false
	
	return true

func _on_interaction_area_body_entered(body) -> void:
	_in_range = true
	player = body
	add_to_group(group_name)
	$AnimationPlayer.play("FadeIN")

func _on_interaction_area_body_exited(body) -> void:
	_in_range = false
	player = null
	remove_from_group(group_name)
	$HBoxContainer.visible = false
