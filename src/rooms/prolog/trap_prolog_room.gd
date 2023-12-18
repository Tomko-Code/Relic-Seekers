extends Room

var current_duration = 0.0
var cycle_duration = 0.75

enum states {
	SPIKES_A,
	TRANSIENT_A,
	SPIKES_B,
	TRANSIENT_B,
}

var state = states.SPIKES_A
@onready var spikes_a = get_tree().get_nodes_in_group("spikes_a")
@onready var spikes_b = get_tree().get_nodes_in_group("spikes_b")

func _ready():
	for spike in spikes_a:
		spike.active = true

func _process(delta):
	current_duration += delta
	if current_duration >= cycle_duration:
		current_duration -= cycle_duration
		match state:
			states.SPIKES_A:
				for spike in spikes_a:
					spike.active = false
				state = states.TRANSIENT_A
			states.TRANSIENT_A:
				for spike in spikes_b:
					spike.active = true
				state = states.SPIKES_B
			states.SPIKES_B:
				for spike in spikes_b:
					spike.active = false
				state = states.TRANSIENT_B
			states.TRANSIENT_B:
				for spike in spikes_a:
					spike.active = true
				state = states.SPIKES_A
