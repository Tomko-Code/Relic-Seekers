class_name ArtifactContainer
extends PanelContainer

var artifact: Artifact = null
@export var shortcut_text = "Q"

func _ready():
	update_artifact()

func update_artifact():
	$Shortcut.text = shortcut_text
	if artifact:
		if artifact is PassiveArtifact:
			update_passive_artifact()
		elif artifact is ActiveArtifact:
			update_active_artifact()
		
	else:
		$MarginContainer/Artifact.texture = null
		$ProgressBar.visible = false
		$Shortcut.visible = false

func update_passive_artifact():
	$MarginContainer/Artifact.texture = artifact.frames.get_frame_texture("default", 0)
	$ProgressBar.visible = false
	$Shortcut.visible = false

func update_active_artifact():
	$ProgressBar.visible = true
	$Shortcut.visible = true
	$MarginContainer/Artifact.texture = artifact.frames.get_frame_texture("default", 0)
	artifact = artifact as ActiveArtifact
	$ProgressBar.max_value = artifact.max_charge
	$ProgressBar.value = artifact.current_charge
	if artifact.can_use():
		$Shortcut.add_theme_color_override("font_color", Color.DARK_GREEN)
	else:
		$Shortcut.add_theme_color_override("font_color", Color.DARK_RED)

func set_artifact(_artifact: Artifact):
	if artifact != null and artifact is ActiveArtifact:
		artifact.charge_changed.disconnect(update_artifact)
		artifact.ready_to_use.disconnect(update_artifact)
		artifact.used.disconnect(update_artifact)
	if _artifact is ActiveArtifact:
		set_active_artifact(_artifact)
	elif artifact is PassiveArtifact:
		set_passive_artifact(_artifact)
	else:
		artifact = _artifact
	update_artifact()

func set_active_artifact(_artifact: ActiveArtifact):
	artifact = _artifact
	artifact.charge_changed.connect(update_artifact)
	artifact.used.connect(update_artifact)
	artifact.ready_to_use.connect(update_artifact)

func set_passive_artifact(_artifact: PassiveArtifact):
	artifact = _artifact

func get_artifact():
	return artifact
