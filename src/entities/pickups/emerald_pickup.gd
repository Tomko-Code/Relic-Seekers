class_name EmeraldPickup
#scene class
extends Node2D

@export var _HitboxComponent: HitboxComponent

func _ready():
	_HitboxComponent.body_entered.connect(on_player_entered)

func on_player_entered(player):
	player = player as PlayerEntity
	GameData.save_file.player_inventory.emeralds += 1
	queue_free()
