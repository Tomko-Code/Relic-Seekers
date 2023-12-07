extends Node

var base_projectile = load("res://src/entities/projectiles/base_projectile.tscn")
var friendly_layer = 8
var hostile_layer = 16


func spawn_projectile(projectile_name, is_friendly: bool):
	if ProjectilesDb.projectiles.has(projectile_name):
		var projectile: BaseProjectile = base_projectile.instantiate()
		var sprite: AnimatedSprite2D = projectile.get_node("Components/AnimatedSpriteComponent/Sprite")
		sprite.sprite_frames = ProjectilesDb.projectiles[projectile_name].sprite
		
		var hitbox: HitboxComponent = projectile.get_node("Components/HitboxComponent")
		if is_friendly:
			hitbox.set_collision_layer(friendly_layer)
		else:
			hitbox.set_collision_layer(hostile_layer)
		return projectile
	return null
