class_name MultiProjectileWrapper
extends RefCounted

var projectiles: Array[BaseProjectile]

func _set(property, value):
	for projectile in projectiles:
		projectile.set(property, value)
