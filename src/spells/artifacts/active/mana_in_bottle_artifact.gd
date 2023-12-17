class_name ManaInBottle
extends ActiveArtifact


func _init():
	max_charge = 200
	frames = load("res://assets/sprites/artifacts/mana_in_bottle.tres")
	
func use():	
	var player = GameManager.player
	
	var mana_orb_pickup = PickupsHandler.create_mana_orb_pickup() as ManaOrbPickup
	var random_direction = Vector2.from_angle(PI*2 * randf()).normalized()
	mana_orb_pickup.position = player.position + (random_direction * 10)
	mana_orb_pickup.push(random_direction)
	player.get_parent().call_deferred("add_child", mana_orb_pickup)
	
	
	print("artifact used!")
	current_charge = 0
	emit_signal("used")

func get_title():
	return "Mana In Bottle"

func get_description():
	return "Spawns a mana orb"

