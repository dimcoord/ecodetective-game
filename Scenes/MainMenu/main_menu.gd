extends Control

var button_type = null 

func _ready() -> void:
	$AudioStreamPlayer.play()
	
	if GameManager.is_new == false:
		$ButtonsRect/NewGameButton/Label.text = "NEW GAME"
		$ButtonsRect/ContinueButton.visible = true
	else:
		$ButtonsRect/NewGameButton/Label.text = "START"
		$ButtonsRect/ContinueButton.visible = false

func _on_exit_button_pressed() -> void:
	button_type = "exit"
	
	# Play click sound.
	$ButtonsRect/ClickSound.play()
	
	# Start fade-out transition.
	$FadeTransition.visible = visible
	$FadeTransition/FadeTimer.start()
	$FadeTransition/AnimationPlayer.play("fade_out")

func _on_continue_button_pressed() -> void:
	button_type = "continue"
	
	# Play click sound.
	$ButtonsRect/ClickSound.play()
	
	# Start fade-in transition.
	$FadeTransition.visible = visible
	$FadeTransition/FadeTimer.start()
	$FadeTransition/AnimationPlayer.play("fade_out")

func _on_new_game_button_pressed() -> void:
	button_type = "new_game"
	
	# Play click sound.
	$ButtonsRect/ClickSound.play()
	
	# Start fade-in transition.
	$FadeTransition.visible = visible
	$FadeTransition/FadeTimer.start()
	$FadeTransition/AnimationPlayer.play("fade_out")

func _on_fade_timer_timeout() -> void:
	if button_type == "continue":
		get_tree().change_scene_to_file("res://Scenes/Cutscene/teleport/teleport_cutscene.tscn")
	elif button_type == "exit":
		get_tree().quit()
	else:
		get_tree().change_scene_to_file("res://Scenes/Cutscene/opening/opening_cutscene.tscn")
