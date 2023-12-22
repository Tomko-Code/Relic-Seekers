class_name ExplosiveEffect
extends ProjectileSpellEffect

var tier
var explosion_tiers = [0.5,0.75,1.0]

func _init():
	effect_type = Constants.effect_types.POSITIVE
	texture = load("res://assets/art/icons/spell_effects/explosion_effect.png")

func init(value):
	tier = clampi(value, 0, 2)
	return self
	
func apply_on_projectile(projectile: BaseProjectile):
	projectile.expired.connect(explode.bind(projectile), CONNECT_ONE_SHOT)

func explode(projectile: BaseProjectile):
	var explosion = ProjectilesHandler.spawn_projectile_explosion(projectile, explosion_tiers[tier])
	explosion.position = projectile.position
	projectile.get_parent().call_deferred("add_child", explosion)

func get_description():
	return get_bbcode_texture() + color_text(" Explosive x%s") % explosion_tiers[tier]
