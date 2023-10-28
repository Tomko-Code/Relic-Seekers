class_name PlayerEntity
extends CharacterBody2D

@export var _UserMovementComponent: UserMovementComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent



func _ready():
	var use_zones = true
	var interpolate_camera_position = true
	var camera_speed = 1
	var near_zone = 300
	var far_zone = 400
	var debug_display = true
	
	GameManager.attach_camera_to_node(self, use_zones, 
		interpolate_camera_position, camera_speed, near_zone, far_zone, 
		debug_display)


func _physics_process(_delta):
	pass


func _on_bullet_hitbox_component_body_entered(body):
	print("i am hit!")
