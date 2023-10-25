extends CharacterBody2D

@export var speed: int = 100
@export var hp: int = 10
var direction: Vector2 = Vector2.ZERO

func _ready():
	pass

func _input(event):
	pass

func _process(delta):
	pass

func _physics_process(delta):
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	move_and_collide(direction.normalized() * delta * speed)
