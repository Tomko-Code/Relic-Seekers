class_name PlayerEntity
extends CharacterBody2D

@export var _UserMovementComponent: UserMovementComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent



func _ready():
	GameManager.attach_camera_to_node(self, true, true,
			3, 300,400, true)


func _physics_process(_delta):
	pass


func _on_bullet_hitbox_component_body_entered(body):
	print("i am hit!")
