extends Node

var base_projectile = load("res://src/entities/projectiles/base_projectile.tscn")
var friendly_layer = 8
var hostile_layer = 16

var all_projectiles = []

func spawn_projectile(projectile_name, is_friendly: bool):
	if ProjectilesDb.projectiles.has(projectile_name):
		var projectile: BaseProjectile = base_projectile.instantiate()
		var sprite: AnimatedSprite2D = projectile.get_node("Components/AnimatedSpriteComponent/Sprite")
		sprite.sprite_frames = ProjectilesDb.projectiles[projectile_name].sprite
		
		projectile.type = projectile_name
		projectile.is_friendly = is_friendly
		
		var hitbox: HitboxComponent = projectile.get_node("Components/HitboxComponent")
		if is_friendly:
			hitbox.set_collision_layer(friendly_layer)
		else:
			hitbox.set_collision_layer(hostile_layer)
			
		
		all_projectiles.append(projectile)
		projectile.expired.connect(clear_projectile.bind(projectile))
		return projectile
	return null

func clear_projectile(projectile):
	all_projectiles.erase(projectile)
	
func clear_all_projectiles():
	for projectile in all_projectiles:
		projectile.queue_free()
	all_projectiles = []

func attach_orbital(target: Node2D, bullet: BaseProjectile, radius: float, cycle_goal):
	var attachment: OrbitalAttachment

	if target.has_meta("OrbitalAttachment"):
		attachment = target.get_meta("OrbitalAttachment", null)
	else:
		attachment = OrbitalAttachment.new()
		target.call_deferred("add_child", attachment)
		target.set_meta("OrbitalAttachment", attachment)
	attachment.add_orbital(bullet, radius, cycle_goal)
	
