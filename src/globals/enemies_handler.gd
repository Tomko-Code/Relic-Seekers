extends Node

var all_enemies = []

func spawn_enemy(enemy_name:String) -> Enemy:
	if EnemiesDb.enemies.has(enemy_name):
		var enemy: Enemy = EnemiesDb.enemies[enemy_name].resource.instantiate()
		all_enemies.append(enemy)
		enemy.tree_exited.connect(clear_enemie.bind(enemy))
		return enemy
	else:
		print("No enemy named: %s" % enemy_name)
		return null

func clear_enemie(enemy):
	all_enemies.erase(enemy)

func clear_all_enemies():
	for enemy in all_enemies:
		enemy.queue_free()
	all_enemies = []

func get_enemy_closest_to(entity: Node2D):
	var closest_enemy = null
	var closest_distance = INF
	for enemy in all_enemies:
		if (enemy.position - entity.position).length() < closest_distance:
			closest_distance = (enemy.position - entity.position).length()
			closest_enemy = enemy
	return closest_enemy
	
