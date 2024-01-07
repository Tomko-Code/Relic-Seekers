extends Node

signal boss_spawned(boss: Enemy)
#signal boss_died

var all_enemies = []

func spawn_boss(enemy_name):
	var enemy = spawn_enemy(enemy_name)
	if enemy == null:
		return null
	else:
		boss_spawned.emit(enemy)
		return enemy

func spawn_enemy(enemy_name:String) -> Enemy:
	if EnemiesDb.enemies.has(enemy_name):
		var enemy: Enemy = EnemiesDb.enemies[enemy_name].resource.instantiate()
		all_enemies.append(enemy)
		enemy.death.connect(clear_enemie.bind(enemy))
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

func get_enemy_closest_to(entity: Node2D, excluded_enemies: Array):
	var closest_enemy = null
	var closest_distance = INF
	for enemy in all_enemies:
		if (enemy.global_position - entity.global_position).length() < closest_distance and enemy not in excluded_enemies:
			closest_distance = (enemy.global_position - entity.global_position).length()
			closest_enemy = enemy
	return closest_enemy
	
