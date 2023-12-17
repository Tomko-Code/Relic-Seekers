extends CanvasLayer

var spawn_list = ["goblin", "stone_eye", "test_mob_a"]
var wave:int = 0

func _ready():
	$"..".enemies_clear.connect($Timer.start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $Timer.is_stopped():
		$CenterContainer/Label.text = "Time to next wave " + str(wave+1) + ": " + str(int($Timer.time_left)) + " ... or press X."
	else:
		$CenterContainer/Label.text = ""
		
func start_wave():
	for x in range(int(pow(wave, 2)/7)+1):
		$"..".spawn_enemy(spawn_list.pick_random())
	
	wave += 1

func _on_timer_timeout():
	start_wave()
	
