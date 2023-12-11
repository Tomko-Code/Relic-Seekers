class_name HealthBarComponent
extends Node2D

@export var _StatsComponent: StatsComponent
@onready var parent = get_parent().get_parent()

func _ready():
	parent.health_changed.connect(update_health)
	update_health()

func _on_timer_timeout():
	update_health()
	
func update_health():
	$Container/ProgressBar.value = (_StatsComponent.current_health / _StatsComponent.max_health) * 100
