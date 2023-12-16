class_name DamageArea
extends Node2D

@export var stats: StatsComponent
@export var hitbox: HitboxComponent

var damage

func _ready():
	damage = stats.shoot_damage
