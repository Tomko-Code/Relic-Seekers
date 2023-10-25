class_name HitboxComponent
extends CollisionShape2D

@export var _Collider: CollisionShape2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_collision(collision: CollisionObject2D):
	if collision:
		
		if _Collider
		get_parent().velocity = get_parent().velocity.slide(collision.get_normal())
		get_parent().move_and_collide(get_parent().velocity * delta)
