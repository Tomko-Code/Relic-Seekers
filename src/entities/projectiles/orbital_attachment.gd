class_name OrbitalAttachment
extends Node2D

#var orbitals = []
#var radius = 100
#var cycle_goal = 5
#var cycle_progress = 0
#var approach_duration = cycle_goal*2

var layers = {
#	example = {
#		orbitals = [],
#		radius = 100,
#		cycle_goal = 5,
#		cycle_progress = 0,
#		approach_duration = cycle_goal*2,
#	}	
}

func add_orbital(bullet: BaseProjectile, _radius: float, _cycle_goal: float):
	print(bullet)
	var layer_key = "R:%sCG:%s" % [_radius, _cycle_goal]
	bullet.set_meta("approach", 0)
	bullet.expired.connect(cleanup_layer.bind(layer_key, bullet))
	if layers.has(layer_key):
		layers[layer_key].orbitals.append(bullet)
	else:
		layers[layer_key] = {
			orbitals = [bullet],
			radius = _radius,
			cycle_goal = _cycle_goal,
			cycle_progress = 0,
			approach_duration = 10
		}

func _physics_process(delta):
	for layer_key in layers:
		process_layer(layers[layer_key], delta)
		
func cleanup_layer(layer_key: String, orbital):
	var layer = layers[layer_key]
	layers[layer_key].orbitals.erase(orbital)
	if layers.is_empty():
		print(layers)
		get_parent().remove_meta("OrbitalAttachment")
		queue_free()

func process_layer(layer: Dictionary, delta: float):
	layer.cycle_progress += delta
	for index in range(layer.orbitals.size()):
		var orbital = layer.orbitals[index]
		var desired_angle = (2*PI) * (float(index) / layer.orbitals.size()) +  (2*PI * (layer.cycle_progress/layer.cycle_goal))
		var desired_angle_vecor = Vector2.from_angle(desired_angle).normalized()
		var desired_position = desired_angle_vecor * layer.radius
		var approach = orbital.get_meta("approach")
		orbital.position = lerp(orbital.position, desired_position, clamp(approach/layer.approach_duration, delta, 1))
		if approach != layer.approach_duration:
			approach = clamp(approach+delta, 0, layer.approach_duration)
			orbital.set_meta("approach", approach)
	if layer.cycle_progress >= layer.cycle_goal:
		layer.cycle_progress -= layer.cycle_goal
	
