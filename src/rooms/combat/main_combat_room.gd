extends Room

var spawned = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	if not spawned:
		var boss = EnemiesHandler.spawn_boss("tezcati")
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
func _process(_delta):
	pass
