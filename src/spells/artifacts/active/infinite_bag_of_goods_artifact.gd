class_name InfiniteBagOfGoods
extends ActiveArtifact


func _init():
	max_charge = 200
	
func use():
	var gold_spawns = randi_range(1,10)
	var emerald_spawns = randi_range(0,1)
	
	var player = GameManager.player
	
	for x in range(gold_spawns):
		var gold_pickup = PickupsHandler.create_gold_pickup() as GoldPickup
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		gold_pickup.position = player.position + (random_direction * 10)
		gold_pickup.push(random_direction)
		player.get_parent().call_deferred("add_child", gold_pickup)
		
	for x in range(emerald_spawns):
		var emerald_pickup = PickupsHandler.create_emerald_pickup() as EmeraldPickup
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		emerald_pickup.position = player.position + (random_direction * 10)
		emerald_pickup.push(random_direction)
		player.get_parent().call_deferred("add_child", emerald_pickup)
		
	
	print("artifact used!")
	current_charge = 0
	emit_signal("used")

func get_title():
	return "Infinite Bag Of Goods"

func get_description():
	return "Spawns between 1-10 gold and 0-1 emeralds"

