extends Node2D

signal interacted
signal focus_change(focus:bool)

@export var box:VBoxContainer
@export var title_lable:RichTextLabel
@export var input_lable:Label
@export var seperator:HSeparator
@export var descryption_lable:RichTextLabel

@export var active: bool = true
@export var interaction_input:InputEvent = null
@export var interaction_descryption:String = ""
@export var interaction_title:String = ""
@export var input_text:String = ""
@export var box_position:Vector2 = Vector2.ZERO
@export var shape: Shape2D = null

var _in_range:bool = false
var player:PlayerEntity = null
var group_name:String

func _ready() -> void:
	box.visible = false
	update_box()

func set_box_position(pos:Vector2):
	box_position = pos
	box.position.x = pos.x - box.size.x/2
	box.position.y = pos.y - box.size.y

# used if somthing changes about the box
func update_box() -> void:
	
	if interaction_descryption == "":
		seperator.hide()
		descryption_lable.text = ""
	else:
		seperator.show()
		descryption_lable.text = interaction_descryption
	
	input_lable.text = ">" + input_text + "<"
	title_lable.text = interaction_title
	
	$InteractionArea/CollisionShape2D.shape = shape
	
	if interaction_input != null:
		group_name = "interactable_" + String.chr(interaction_input.keycode)
	
	set_box_position(box_position)
	

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
	emit_signal("focus_change", _in_range)
	player = body
	add_to_group(group_name)
	$AnimationPlayer.play("FadeIN")

func _on_interaction_area_body_exited(body) -> void:
	_in_range = false
	emit_signal("focus_change", _in_range)
	player = null
	remove_from_group(group_name)
	box.visible = false

func _on_box_item_rect_changed():
	set_box_position(box_position)
	update_box()
