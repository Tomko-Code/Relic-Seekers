class_name HomingEffect
extends ProjectileSpellEffect

func _init():
	effect_type = Constants.effect_types.POSITIVE
	texture = load("res://assets/art/icons/spell_effects/homing.png")

func apply_on_projectile(projectile: BaseProjectile):
	projectile.launched.connect(override_movement.bind(projectile))

func override_movement(projectile: BaseProjectile):
	projectile.launched.disconnect(override_movement.bind(projectile))
	projectile.get_node("Components").add_child.call_deferred(ProjectileHomingSystem.new())
	
	#var projectile_movement = GameManager.get_entity_component(projectile, ProjectileMovementComponent)[0] as ProjectileMovementComponent
	#var shadow = projectile_movement._EntityShadowComponent
	#projectile_movement.set_script(HomingProjectileMovementComponent)
	#projectile_movement._EntityShadowComponent = shadow
	#projectile.launch(projectile.launch_direction)

func get_description():
	return get_bbcode_texture() + color_text(" Homing")
