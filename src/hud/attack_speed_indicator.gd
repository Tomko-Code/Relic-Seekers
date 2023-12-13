extends Control

var radius = 60

var shoot_frequency_max = 2.0
var shoot_frequency_current = 0

var player_stats: PlayerStatsComponent
var shooting_component: UserMouseShootingComponent

func _ready():
	if GameManager.player != null:
		shoot_frequency_current = 0
		set_process(false)
		$DurationLabel.text = ""
		player_stats = GameManager.get_entity_component(GameManager.player, PlayerStatsComponent)[0]
		shooting_component = GameManager.get_entity_component(GameManager.player, UserMouseShootingComponent)[0]
		shooting_component.on_shoot.connect(on_shoot)
	if get_parent() != get_node("/root"):
		var parent_size = get_parent().get_size()
		var higher_value = parent_size.x if parent_size.x > parent_size.y else parent_size.y
		radius = higher_value/2 - 8

func on_shoot():
	shoot_frequency_max = player_stats.get_shoot_frequency()
	shoot_frequency_current = 0
	set_process(true)

func _draw():
	draw_arc(Vector2.ZERO, radius, 0, 2*PI * (shoot_frequency_current/shoot_frequency_max),100,Color.RED,2,true)

func _process(delta):
	shoot_frequency_current += delta
	$DurationLabel.text = "%.1f" % shoot_frequency_current
	if shoot_frequency_current >= shoot_frequency_max:
		shoot_frequency_current = 0
		set_process(false)
		$DurationLabel.text = ""
	queue_redraw()
