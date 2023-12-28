extends StaticBody2D

@export var room:Room = null
@export var lable:Label = null
@export var timer:Timer = null

var spawn_list = ["goblin", "stone_eye"]
var wave:int = 0

func _ready():
	lable.text = ""
	room.enemies_clear.connect(start_timer)
	timer.timeout.connect(clear_msg)
	
	wave = GameData.save_file.wave

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _exit_tree():
	pass

func clear_msg():
	lable.text = ""

func start_wave():
	lable.text = "Wave : " + str(wave+1)
	GameData.save_file.wave = wave
	#FLOOR.MATH((B5/2)+(1)+((B5^3)/(B5*16)))
	var fix_wave:int = wave+1
	var mod1:float = fix_wave/2
	var mod2:int = 1
	var mod3:float = (fix_wave^3)/(fix_wave*16)
	var result:int = floor(mod1+mod2+mod3)
	
	for x in range(result):
		$"..".spawn_enemy(spawn_list.pick_random())
	
	wave += 1

func _on_timer_timeout():
	print($"..".enemy_count)
	start_wave()

func _on_interactable_component_interacted():
	if room.enemy_count == 0 and $AutoPickTimer.is_stopped():
		timer.start()
		start_wave()

func start_timer():
	$AutoPickTimer.start()
	lable.text = "Wave Ceared!"

func _on_auto_pick_timer_timeout():
	clear_msg()
	for auto in get_tree().get_nodes_in_group("auto_pick"):
		auto.auto_pick = true
