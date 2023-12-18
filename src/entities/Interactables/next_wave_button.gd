extends StaticBody2D

@export var room:Room = null
@export var lable:Label = null
@export var timer:Timer = null

var spawn_list = ["goblin", "stone_eye", "test_mob_a"]
var wave:int = 0

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not timer.is_stopped():
		lable.text = "Wave : " + str(wave)
	else:
		lable.text = ""
		
func start_wave():
	for x in range(int(pow(wave, 2)/7)+1):
		$"..".spawn_enemy(spawn_list.pick_random())
	
	wave += 1

func _on_timer_timeout():
	print($"..".enemy_count)
	start_wave()

func _on_interactable_component_interacted():
	if room.enemy_count <= 0:
		timer.start()
		start_wave()
