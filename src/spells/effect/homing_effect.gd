class_name HomingEffect
extends ProjectileSpellEffect


func apply_on_projectile(projectile: BaseProjectile):
	projectile.launched.connect(override_movement.bind(projectile))

func override_movement(projectile: BaseProjectile):
	projectile.launched.disconnect(override_movement.bind(projectile))
	var projectile_movement = GameManager.get_entity_component(projectile, ProjectileMovementComponent)[0] as ProjectileMovementComponent
	var shadow = projectile_movement._EntityShadowComponent
	projectile_movement.set_script(HomingProjectileMovementComponent)
	projectile_movement._EntityShadowComponent = shadow
	projectile.launch(projectile.launch_direction)

func get_description():
	return "Homing: projectile follows closest enemy"
