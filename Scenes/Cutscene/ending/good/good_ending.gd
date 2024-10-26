extends Node2D

@onready var save_file: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	$Cutscene/TextBox/AnimationPlayer.play("tpyewriter")
	$Cutscene/Timer.start()
	
	# Untuk player
	$PlayerAmbatekkom.max_speed = 0
	
	if GameManager.username != null:
		$Cutscene/TextBox/LineEdit.text = GameManager.username

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$Cutscene/TextBox/Text4.text = "GERAKKAN  KARAKTER  KE  BAWAH  UNTUK  MELANJUTKAN!"
	$PlayerAmbatekkom.max_speed = 30


func _on_area_2d_body_entered(body: Node2D) -> void:
	$PlayerAmbatekkom.move_direction = Vector2.DOWN
	$PlayerAmbatekkom.is_moving = true
	$PlayerAmbatekkom.is_input_locked = true
	$Cutscene/CreditsTheme.play()
	$Control/CanvasLayer/ControlButton.visible = false
	$Cutscene/CreditsTimer.start()


func _on_credits_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
