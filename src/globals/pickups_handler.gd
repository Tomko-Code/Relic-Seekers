extends Node

var gold_resource = load("res://src/entities/pickups/gold_pickup.tscn")
var emerald_resource = load("res://src/entities/pickups/emerald_pickup.tscn")
var artifact_resource = load("res://src/entities/pickups/artifact_pickup.tscn")
var mana_orb_resource = load("res://src/entities/pickups/mana_orb_pickup.tscn")


func create_gold_pickup():
	return gold_resource.instantiate()

func create_emerald_pickup():
	return emerald_resource.instantiate()

func create_mana_orb_pickup():
	return mana_orb_resource.instantiate()

func create_artifact_pickup(artifact: Artifact):
	var artifact_pickup = artifact_resource.instantiate()
	artifact_pickup.set_artifact(artifact)
	return artifact_pickup
	
func create_artifact(artifact_name: String):
	if ArtifactsDb.artifacts.has(artifact_name):
		return ArtifactsDb.artifacts[artifact_name].new()
	else:
		print("missing artifact name: %s" % artifact_name)
		return null
