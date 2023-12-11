extends Node

var all_enemies = []

func spawn_projectile(enemy_name):
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
