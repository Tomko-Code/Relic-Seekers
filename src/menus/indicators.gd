extends Control

var texture = preload("res://assets/art/UI/big_arrow.svg")

func _ready():
	pass # Replace with function body.

#func _physics_process(delta):
#	queue_redraw()

func _process(delta):
	queue_redraw()

func _draw():
	var camera:Camera2D = GameManager.game_camera.Camera
	if camera == null:
		return
	#var poss = camera.position # Camera's center
	#var half_size = get_viewport_rect().size * 0.5
	#print(camera.get_viewport_rect())
	#print(Rect2(poss - half_size, poss + half_size))
	
	for enemy in EnemiesHandler.all_enemies:
		if enemy.global_position.distance_to(GameManager.player.position) > 1500:
			var angle = Vector2(0,1).angle()
			var pos = enemy.global_position - GameManager.player.position
			pos.x = clamp(pos.x,0+64,1152-64)
			pos.y = clamp(pos.y,0+64,648-64)
			print(pos)
			#draw_set_transform((texture.get_size() * 0.5).rotated(angle + 5/4 * PI), angle, Vector2.ONE)
			#draw_texture(texture, pos.rotated(-angle))
			draw_texture(texture, pos)
