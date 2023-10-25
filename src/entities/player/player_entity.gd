class_name PlayerEntity
extends CharacterBody2D

@export var _UserMovementComponent: UserMovementComponent
@export var _AnimatedSpriteComponent: AnimatedSpriteComponent
@export var Camera: Camera2D



func _ready():
	Camera.make_current()


func _physics_process(_delta):
	pass


func _on_bullet_hitbox_component_body_entered(body):
	print("i am hit!")
