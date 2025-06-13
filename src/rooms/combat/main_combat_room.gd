extends Room

var spawned = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#var enemy1 = EnemiesHandler.spawn_enemy("goblin")
	#var enemy2 = EnemiesHandler.spawn_enemy("goblin")
	#add_child(enemy1)
	#add_child(enemy2)
	#enemy1.position = $Marker2D.position
	#enemy2.position = $Marker2D.position
	
	if not spawned:
		var boss = EnemiesHandler.spawn_boss("boss_eye")
		enemy_count = 1
		boss.death.connect(on_enemy_death)
		var spawn_point = spawn_point_res.instantiate() as SpawnerPoint
		boss.position = $SpawnSpot.position
		spawn_point.animation_player.speed_scale = 0.5
		spawn_point.position = $SpawnSpot.position
		spawn_point.enemy = boss
		spawn_point.room = self
		
		add_child.call_deferred(spawn_point)
		spawned = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
