extends Button

func _input(event):
	if Input.is_action_just_pressed("back"):
		_on_pressed()

func _on_pressed():
	$"../../../../MainMenu".show()
	$"../../../../Options".hide()
