class_name TestArtifactSpawn
extends Marker2D

@export var artifact_name: String = ""

func _ready():
	var artifact = PickupsHandler.create_artifact(artifact_name)
	var artifact_pickup = PickupsHandler.create_artifact_pickup(artifact)
	artifact_pickup.position = position
	get_parent().call_deferred("add_child", artifact_pickup)
	queue_free()
