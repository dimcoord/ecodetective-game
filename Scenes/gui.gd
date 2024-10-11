extends Control

func _ready():
	$FadeTransition.visible = false
	$PauseMenu.visible = false

func _process(delta):
	pass	

func _on_pause_button_pressed() -> void:
	$ClickSound.play()
	$PauseMenu.visible = true
	$PauseButton.visible = false


func _on_resume_button_pressed() -> void:
	$ClickSound.play()
	$PauseMenu.visible = false
	$PauseButton.visible = true


func _on_quit_button_pressed() -> void:
	$FadeTransition.visible = true
	$FadeTransition/FadeTimer.start()
	$FadeTransition/AnimationPlayer.play("fade_out")
	# Harus save game dulu setiap quit ke main menu

func _on_fade_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
