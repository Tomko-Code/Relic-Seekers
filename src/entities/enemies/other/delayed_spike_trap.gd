class_name DelayedSpikeTrap
extends SpikeTrap

@onready var proximity_hitbox: HitboxComponent = $Components/ProximityHitbox
@onready var timer: Timer = $Timer

func _ready():
	proximity_hitbox.body_entered.connect(player_near)
	proximity_hitbox.body_exited.connect(player_far)
	timer.timeout.connect(switch_active_state)

func player_near(_entity):
	if not timer.is_stopped():
		return
	if active:
		return
	else:
		timer.start()

func player_far(_entity):
	if not timer.is_stopped():
		await timer.timeout
	if not active:
		return
	else:
		timer.start()

func switch_active_state():
	if switching:
		await sprite.animation_finished
	active = !active
