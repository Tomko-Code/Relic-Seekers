extends Node

var base_projectile = load("res://src/entities/projectiles/base_projectile.tscn")
var explosion_area_resource = load("res://src/entities/projectiles/explosion_area.tscn")
var friendly_layer = 8
var hostile_layer = 16

var hostile_projectile_pool_id: int
var all_projectiles = []

func _ready():
	hostile_projectile_pool_id = PoolManager.register_pool(base_projectile)

func spawn_projectile(projectile_name, is_friendly: bool):
	if ProjectilesDb.projectiles.has(projectile_name):
		var projectile: BaseProjectile
		if is_friendly:
			projectile = base_projectile.instantiate()
		else:
			projectile = PoolManager.get_object(hostile_projectile_pool_id)
		var sprite: AnimatedSprite2D = projectile.get_node("Components/AnimatedSpriteComponent/Sprite")
		sprite.sprite_frames = ProjectilesDb.projectiles[projectile_name].sprite
		
		projectile.type = projectile_name
		projectile.projectile_data.type = projectile_name
		
		projectile.launch(Vector2.ZERO)
		
		set_projectile_layer(projectile, is_friendly)
		
		all_projectiles.append(projectile)
		projectile.expired.connect(clear_projectile.bind(projectile))
		return projectile
	return null

func spawn_projectile_explosion(projectile: BaseProjectile, damage_modifier: float):
	var explosion_area = explosion_area_resource.instantiate() as ExplosionArea
	explosion_area.from_projectile(projectile)
	explosion_area.damage *= damage_modifier
	return explosion_area

func free_projectile(projectile: BaseProjectile):
	if projectile.is_friendly:
		projectile.queue_free()
	else:
		PoolManager.release_object(hostile_projectile_pool_id, projectile)
		

func clear_projectile(projectile):
	projectile.expired.disconnect(clear_projectile.bind(projectile))
	all_projectiles.erase(projectile)
	
func clear_all_projectiles():
	for projectile in all_projectiles:
		projectile.queue_free()
	all_projectiles = []

func set_projectile_layer(projectile: BaseProjectile, is_friendly: bool):
	projectile.is_friendly = is_friendly
	var hitbox: HitboxComponent = projectile.get_node("Components/HitboxComponent")
	if is_friendly:
		#hitbox.set_collision_layer(friendly_layer)
		#hitbox.set_collision_mask_value(3,1)
		#projectile.set_collision_layer(friendly_layer)
		projectile.set_collision_mask_value(3, 1)
	else:
		#hitbox.set_collision_layer(hostile_layer)
		#hitbox.set_collision_mask_value(1,1)
		#projectile.set_collision_layer(hostile_layer)
		projectile.set_collision_mask_value(1, 1)

func attach_orbital(target: Node2D, bullet: BaseProjectile, radius: float, cycle_goal):
	var attachment: OrbitalAttachment

	if target.has_meta("OrbitalAttachment"):
		attachment = target.get_meta("OrbitalAttachment", null)
	else:
		attachment = OrbitalAttachment.new()
		target.call_deferred("add_child", attachment)
		target.set_meta("OrbitalAttachment", attachment)
	attachment.add_orbital(bullet, radius, cycle_goal)
	
