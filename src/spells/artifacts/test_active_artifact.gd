class_name TestActiveArtifact
extends ActiveArtifact


func _init():
	#frames = null
	max_charge = 10
	pass

func use():
	print("artifact used!")
	current_charge = 0
	emit_signal("used")

func get_title():
	return "Active Test Artifact"

func get_description():
	return "Active Test Artifact Description"

