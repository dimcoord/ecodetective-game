extends Node2D

var save_path := "user://player_data.json"
var username = null

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_user()
	
	$Cutscene/TextBox/AnimationPlayer.play("tpyewriter")
	$Cutscene/Timer.start()
	
	# Untuk player
	$PlayerAmbatekkom.max_speed = 0
	
	if username != null:
		$Cutscene/TextBox/LineEdit.text = username

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
