extends Node2D
@export var animation_system: FourDirectionMovementSystemExtra

@export var animation: AnimatedSpriteComponent
@export var follow_behaviour: FollowEnemyBehaviour
@export var shooting_behaviour: ShootAtEnemyBehaviour
@export var shooting: ShootInDirectionComponent

@export var stats: StatsComponent

@export var clock: Timer
@export var extra_clock: Timer

@export var spawner_projectile:PackedScene = null
@export var shard_projectile:PackedScene = null

var room:Room = null
enum states { zero, idle, move, random_move, spawn, shard_attack, shard_spiral_attack}
var current_state: states = states.zero
var previouse_state: states = states.zero

var random_move_timer: Timer 
var random_move_position: Vector2

## position boss will move to
var move_position: Vector2

var spawner_projectile_timer: float
var shard_projectile_timer: float
# use for both start (cooldown) and length of attack
var shard_spiral_timer: float
var shard_spiral_shot_timer:float
var dir_siral:Vector2

func _ready():
	move_position = position
	room = _get_room()
	
	random_move_timer = Timer.new()
	random_move_timer.one_shot = true
	random_move_timer.wait_time = 2
	random_move_timer.timeout.connect(_on_random_move_timer)
	add_child(random_move_timer)
	
	set_state( states.random_move )

func set_state(state: states) -> void:
	if state == current_state:
		return
	
	previouse_state = current_state
	current_state = state
	
	match state:
		states.idle:
			_set_idle()
		states.move:
			_set_move()
		states.random_move:
			_set_random_move()
		states.spawn:
			_set_spawn()
		states.shard_attack:
			_set_shard_attack()
		states.shard_spiral_attack:
			_set_shard_spiral_attack()
		

func _process(delta: float) -> void:
	spawner_projectile_timer += delta
	shard_projectile_timer += delta
	shard_spiral_timer += delta
	shard_spiral_shot_timer += delta
	
	_process_state(current_state, delta)

func _process_state(state: states, delta: float) -> void:
	match state:
		states.idle:
			_idle_update()
		states.move:
			_move_update()
		states.random_move:
			_random_move_update(delta)
		states.spawn:
			_spawn_update()
		states.shard_attack:
			_shard_attack_update()
		states.shard_spiral_attack:
			_shard_spiral_attack_update()

func _set_shard_spiral_attack() -> void:
	print("_set_shard_spiral_attack")
	$AnimatedSpriteComponent/AnimatedSprite2D.play("hand_up")
	shard_spiral_shot_timer = 0.0
	shard_spiral_timer = 0.0
	var pos:Vector2 = get_parent().position
	dir_siral = pos.direction_to(GameManager.player.position - room.global_position)

func _shard_spiral_attack_update() -> void:
	if shard_spiral_shot_timer > 0.2:
		shard_spiral_shot_timer -= 0.2
		var pos:Vector2 = get_parent().position
		shoot_shard(pos, dir_siral, true)
		if GameData.save_file.cores_placed > 1:
			shoot_shard(pos, -dir_siral, true)
		dir_siral = dir_siral.rotated(0.21)
	
	# reset opf spell condition
	if shard_spiral_timer > 3 + GameData.save_file.cores_placed:
		set_state(states.random_move)
		shard_spiral_timer = 0.0

func _set_shard_attack() -> void:
	print("_set_shard_attack")
	$AnimatedSpriteComponent/AnimatedSprite2D.play("hand_up")
	shard_projectile_timer = 0


func _shard_attack_update() -> void:
	pass

func _idle_update() -> void:
	pass

func _set_idle() -> void:
	print("_set_idle")
	$AnimatedSpriteComponent/AnimatedSprite2D.play("idle")

func _spawn_update() -> void:
	pass

func _set_spawn() -> void:
	print("_set_spawn")
	$AnimatedSpriteComponent/AnimatedSprite2D.play("hand_up")
	spawner_projectile_timer = 0

func _move_update() -> void:
	pass

func _set_move() -> void:
	print("_set_move")
	$AnimatedSpriteComponent/AnimatedSprite2D.play("idle")

func _random_move_update(delta: float) -> void:
	get_parent().position += get_parent().position.direction_to(random_move_position).normalized() * 80 * delta
	
	var shard_time: float = 4
	var spawn_time: float = 5
	var spiral_time: float = 10
	
	if GameData.save_file.cores_placed >= 2:
		shard_time = 3
		spawn_time = 4
		spiral_time = 9
	
	if GameData.save_file.cores_placed >= 3:
		spawn_time = 3.5
	
	if spawner_projectile_timer > spawn_time:
		set_state(states.spawn)
	elif shard_projectile_timer > shard_time:
		set_state(states.shard_attack)
	elif shard_spiral_timer > spiral_time:
		set_state(states.shard_spiral_attack)

func shoot_shard(position: Vector2, direction: Vector2, back: bool = false) -> void:
	var shard:Node2D = shard_projectile.instantiate()
	shard.rotation = direction.angle()
	shard.direction = direction
	shard.on_inpact_delete = !back
	shard.boss = get_parent()
	shard.position = position
	room.add_child(shard)

func _set_random_move() -> void:
	print("_set_random_move")
	$AnimatedSpriteComponent/AnimatedSprite2D.play("idle")
	
	set_new_random_move_position()
	random_move_timer.start()

func _on_random_move_timer() -> void:
	set_new_random_move_position()
	random_move_timer.start()

func spawn_spawner_projectile(destination: Vector2) -> void:
	var projectile:Node2D = spawner_projectile.instantiate()
	projectile.destination = destination
	
	projectile.position = get_parent().position
	room.add_child(projectile)

func _get_room() -> Room:
	var game:Game = GameManager.loaded_scenes["Game"]
	return game.active_level.currnet_active_room

func set_new_random_move_position() -> void:
	var min = 200
	var max = 400
	
	while true:
		random_move_position = get_random_position_in_room()
		var distance = (room.global_position + random_move_position).distance_to(GameManager.player.position)
		
		if distance > 150 and distance < 450:
			return
		
		max += 5

func get_random_position_in_room() -> Vector2:
	#return Vector2.ZERO
	return Vector2(randi_range(200, 2000), randi_range(200, 1700))

func _on_animated_sprite_2d_animation_finished() -> void:
	# setting animation of hand down after spawn or shard attack
	if current_state == states.spawn:
		if $AnimatedSpriteComponent/AnimatedSprite2D.animation == "hand_up":
			spawn_spawner_projectile(GameManager.player.position - room.position)
			$AnimatedSpriteComponent/AnimatedSprite2D.play("hand_down")
		else:
			set_state(states.random_move)
	elif current_state == states.shard_attack:
		if $AnimatedSpriteComponent/AnimatedSprite2D.animation == "hand_up":
			var pos:Vector2 = get_parent().position
			var dir:Vector2 = pos.direction_to(GameManager.player.position - room.global_position)
			shoot_shard(pos, dir)
			
			if GameData.save_file.cores_placed >= 1:
				shoot_shard(pos, dir.rotated(0.1))
				shoot_shard(pos, dir.rotated(-0.1))
			
			if GameData.save_file.cores_placed >= 2:
				shoot_shard(pos, dir.rotated(0.2))
				shoot_shard(pos, dir.rotated(-0.2))
			
			if GameData.save_file.cores_placed >= 3:
				shoot_shard(pos, dir.rotated(0.3))
				shoot_shard(pos, dir.rotated(-0.3))
			
			$AnimatedSpriteComponent/AnimatedSprite2D.play("hand_down")
		else:
			set_state(states.random_move)
	#elif current_state == states.shard_spiral_attack:
		#if $AnimatedSpriteComponent/AnimatedSprite2D.animation == "hand_up":
			#var pos:Vector2 = get_parent().position
			#var dir:Vector2 = pos.direction_to(GameManager.player.position - room.global_position)
			#shoot_shard(pos, dir)
			#shoot_shard(pos, dir.rotated(0.1))
			#shoot_shard(pos, dir.rotated(-0.1))
			#$AnimatedSpriteComponent/AnimatedSprite2D.play("hand_down")
		#else:
			#set_state(states.random_move)

func spiral_shard_attatck():
	pass
