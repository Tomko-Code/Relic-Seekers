extends Node


func _ready():
	#func initialize(_speed: float, _range: float, _damage: float,_effects: Array):
	GameManager.player = $Map/PlayerEntity
	$CanvasLayer/player_health_display.fill_hearts()
	$CanvasLayer/player_health_display.re_connect()
	$Map/HostileProjectile.initialize(0, 10, 1, [])
