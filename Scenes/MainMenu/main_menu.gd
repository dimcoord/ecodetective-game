extends Control

var save_path := "user://player_data.json"
var username = null

var button_type = null 

func load_user() -> void:
	if not FileAccess.file_exists(save_path):
		return
	var file_access := FileAccess.open(save_path, FileAccess.READ)
	var json_string := file_access.get_line()
	file_access.close()

	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data:Dictionary = json.data
	username = data.get("username")

func _ready() -> void:
	load_user()
	
	$AudioStreamPlayer.play()
	
	if username != null:
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
