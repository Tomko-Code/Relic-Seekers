extends Room


# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy1 = EnemiesHandler.spawn_enemy("goblin")
	var enemy2 = EnemiesHandler.spawn_enemy("goblin")
	add_child(enemy1)
	add_child(enemy2)
	enemy1.position = $Marker2D.position
	enemy2.position = $Marker2D.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
