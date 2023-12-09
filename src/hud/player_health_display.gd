extends MarginContainer

var current_health = 6
var max_health = 6

func _ready():
	if GameManager.player:
		GameManager.player.health_changed.connect(fill_hearts)
	fill_hearts()

func re_connect():
	if GameManager.player:
		GameManager.player.health_changed.connect(fill_hearts)

func set_health():
	if not GameManager.player:
		return
	var player = GameManager.player
	var player_stats: PlayerStatsComponent = GameManager.get_entity_component(player, PlayerStatsComponent)[0]
	
	current_health = player_stats.current_health as int
	max_health = player_stats.max_health as int

func fill_hearts():
	set_health()
	
	for child in $Hearts.get_children():
		child.queue_free()

	for full_hearts in range(floor(current_health / 2)):
		var sprite = TextureRect.new()
		sprite.expand_mode = sprite.EXPAND_FIT_WIDTH_PROPORTIONAL
		sprite.texture = load("res://assets/art/icons/full_heart.tres")
		$Hearts.add_child(sprite)
	
	if current_health % 2:
		var sprite = TextureRect.new()
		sprite.expand_mode = sprite.EXPAND_FIT_WIDTH_PROPORTIONAL
		sprite.texture = load("res://assets/art/icons/half_heart.tres")
		$Hearts.add_child(sprite)
	
	for full_hearts in range(floor((max_health - current_health) / 2)):
		var sprite = TextureRect.new()
		sprite.expand_mode = sprite.EXPAND_FIT_WIDTH_PROPORTIONAL
		sprite.texture = load("res://assets/art/icons/empty_heart.tres")
		$Hearts.add_child(sprite)
	
