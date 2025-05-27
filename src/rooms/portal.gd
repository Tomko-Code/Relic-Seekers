extends Sprite2D


@export var pillar_0:TeleportPilar
@export var pillar_1:TeleportPilar
@export var pillar_2:TeleportPilar

func _ready() -> void:
	pillar_0.connect("pilar_activated", pillar_0_action);
	pillar_1.connect("pilar_activated", pillar_1_action);
	pillar_2.connect("pilar_activated", pillar_2_action);
	
	if GameData.save_file.core_activation_data[0]:
		material.set_shader_parameter("radius_0", 1.0)
		
	if GameData.save_file.core_activation_data[1]:
		material.set_shader_parameter("radius_1", 1.0)
		
	if GameData.save_file.core_activation_data[2]:
		material.set_shader_parameter("radius_2", 1.0)

func pillar_0_action() -> void:
	$AnimationPlayer.play("activate_0")

func pillar_1_action() -> void:
	$AnimationPlayer.play("activate_1")

func pillar_2_action() -> void:
	$AnimationPlayer.play("activate_2")
