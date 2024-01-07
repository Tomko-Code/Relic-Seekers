extends Control

var boss: Enemy = null

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var boss_label: Label = $VBoxContainer/Label

func _ready():
	update_stats()
	EnemiesHandler.boss_spawned.connect(set_boss)

func set_boss(_boss: Enemy):
	if boss != null and is_instance_valid(boss) and not boss.is_queued_for_deletion():
		boss.death.disconnect(boss_death)
	boss = _boss
	boss.death.connect(boss_death)
	set_physics_process(true)
	update_stats()

func boss_death():
	boss = null
	update_stats()

func update_stats():
	if boss == null:
		set_physics_process(false)
		hide()
	else:
		var boss_stats = GameManager.get_entity_component(boss, StatsComponent) as Array
		if boss_stats.size() == 0:
			boss_death()
		boss_stats = boss_stats[0] as StatsComponent
		progress_bar.max_value = boss_stats.max_health
		progress_bar.value = boss_stats.current_health
		boss_label.text = boss.name.capitalize()
		show()

func _physics_process(delta):
	update_stats()
