extends Control

var button_type = null

func _ready():
	#$Music.play()
	pass

func _process(delta):
	pass

func load_game():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_start_button_pressed() -> void:
	button_type = "start"
	
	# Play click sound.
	$ButtonsRect/ClickSound.play()
	
	# Start fade-in transition.
	$FadeTransition.show()
	$FadeTransition/FadeTimer.start()
	$FadeTransition/AnimationPlayer.play("fade_out")

func _on_exit_button_pressed() -> void:
	button_type = "exit"
	
	# Play click sound.
	$ButtonsRect/ClickSound.play()
	
	# Start fade-out transition.
	$FadeTransition.show()
	$FadeTransition/FadeTimer.start()
	$FadeTransition/AnimationPlayer.play("fade_out")


func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		load_game()
	elif button_type == "exit":
		get_tree().quit()
