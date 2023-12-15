class_name TestPassiveArtifact
extends PassiveArtifact


func _init():
	#frames = null
	pass

func enable():
	print("test artifact enabled!")

func disable():
	print("test artifact disabled!")

func get_title():
	return "Passive Test Artifact"

func get_description():
	return "Passive Test Artifact Description"
