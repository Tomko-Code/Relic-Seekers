extends TextureButton

var simple_texture: Texture2D = preload("res://assets/art/sprites/teleports/simple_circle_teleport.png")
var simple_texture_hover: Texture2D = preload("res://assets/art/sprites/teleports/simple_circle_teleport_hover.png")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_simple_cirlce() -> void:
	texture_normal = simple_texture
	texture_pressed = simple_texture
	texture_hover = simple_texture_hover

func _on_pressed():
	print("tp")
