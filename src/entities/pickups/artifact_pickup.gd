class_name ArtifactPickup
extends GenericPickup

var artifact: Artifact = null


func set_artifact(_artifact: Artifact):
	artifact = _artifact
	
	var interactable = $Components/InteractableComponent as InteractibleComponent
	$Components/AnimatedSpriteComponent/Sprite.sprite_frames = artifact.frames
	
	interactable.interaction_descryption = artifact.get_description()
	interactable.interaction_title = artifact.get_title()
	
	interactable.interacted.connect(pickup_artifact)
	
	interactable.update_box()

func delete():
	artifact.queue_free()
	queue_free()

func pickup_artifact():
	var ret_artifact = GameData.save_file.player_inventory.add_artifact(artifact)
	if ret_artifact:
		var new_pickup = PickupsHandler.create_artifact_pickup(ret_artifact)
		new_pickup.position = position
		get_parent().call_deferred("add_child", new_pickup)
	SoundManager.play_sfx("pickup_sfx")
	queue_free()

func get_description():
	return artifact.get_description()

func get_title():
	return artifact.get_title()
