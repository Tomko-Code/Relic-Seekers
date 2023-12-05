extends Zone

func on_zone_enter(zone_spawn:int = 0):
	GameManager.player.global_position = $Spawns/Spawn.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
