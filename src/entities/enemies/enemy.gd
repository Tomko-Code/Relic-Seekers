class_name Enemy
extends CharacterBody2D


func _on_bullet_hitbox_component_body_entered(body):
	queue_free()
	body.queue_free()
	
