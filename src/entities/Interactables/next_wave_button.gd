extends StaticBody2D

@export var room:Room = null
@export var lable:Label = null
@export var timer:Timer = null

var spawn_list = ["goblin", "stone_eye"]
var wave:int = 0

func _ready():
	room.enemies_clear.connect(start_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not timer.is_stopped():
		lable.text = "Wave : " + str(wave)
	else:
		lable.text = ""
		
func start_wave():
	#FLOOR.MATH((B5/2)+(1)+((B5^3)/(B5*16)))
	var mod1:int = wave/2
	var mod2:int = 1
	var mod3:int = (wave^3)/(wave*16)
	
	for x in range(floor(mod1+mod2+mod3)):
		$"..".spawn_enemy(spawn_list.pick_random())
	
	wave += 1

func _on_timer_timeout():
	print($"..".enemy_count)
	start_wave()

func _on_interactable_component_interacted():
	print(room.enemy_count)
	if room.enemy_count == 0:
		timer.start()
		start_wave()

func start_timer():
	$AutoPickTimer.start()

func _on_auto_pick_timer_timeout():
	for auto in get_tree().get_nodes_in_group("auto_pick"):
		auto.auto_pick = true
