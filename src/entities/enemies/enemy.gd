class_name Enemy
extends CharacterBody2D

signal health_changed
signal death


func call_death():
	emit_signal("death")
	spawn_loot()
	queue_free()

func spawn_loot():
	var spawn_gold:bool = randi() % 5 == 0
	var spawn_emerald:bool = randi() % 20 == 0
	
	if spawn_gold:
		var gold_pickup = PickupsHandler.create_gold_pickup() as GoldPickup
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		gold_pickup.position = position + (random_direction * 10)
		gold_pickup.push(random_direction)
		get_parent().call_deferred("add_child", gold_pickup)
		
	if spawn_gold:
		var emerald_pickup = PickupsHandler.create_emerald_pickup() as EmeraldPickup
		var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
		emerald_pickup.position = position + (random_direction * 10)
		emerald_pickup.push(random_direction)
		get_parent().call_deferred("add_child", emerald_pickup)
