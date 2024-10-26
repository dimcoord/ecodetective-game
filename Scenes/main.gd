extends Node2D

@onready var music
var iterator = 1
var map

func showLevel() -> void:
	$Control/CanvasLayer/UsernameText.text = GameManager.username
	$Control/CanvasLayer/LevelText/PlayerLevel.text = str(GameManager.level)

func playFadeIn() -> void:
	$FadeTransition.visible = true
	$FadeTransition/AnimationPlayer.play("fade_in")

func playCinematicScreen() -> void:
	$Control/CanvasLayer.visible = false
	$CanvasLayer/CinematicScreen/Screen/AnimationPlayer.play("curtains_in")

func playOpeningCutscene() -> void:
	$CanvasLayer.visible = true
	playCinematicScreen()
	
	$PlayerAmbatekkom.is_input_locked = true
	$PlayerAmbatekkom.is_moving = true
	$PlayerAmbatekkom.move_direction = Vector2.UP
	$OpeningCutscene/MoveTimer.start()

func initiateDefaultAnims() -> void:
	$MapDefaultPos/Portal.play("default")
	$MapDefaultPos/Portal.visible = false
	$OpeningCutscene/AnimationPlayer.play("RESET")
	$NPC_Pedagang1/AnimationPlayer.play("RESET")
	$NPC_Cewek/AnimationPlayer.play("RESET")
	$Control/CanvasLayer/PauseMenu.visible = false
	$NPC_Cewek/DialogBox/Text1.visible = true
	$NPC_Cewek/DialogBox/Text2.visible = false

func notCibiru() -> void:
	$MapDefaultPos.position = Vector2(0, -100)
	$PlayerAmbatekkom.position = Vector2(250, 200)
	$NPC_Cewek.queue_free()
	$NPC_Pedagang1.queue_free()

func preloadMap() -> void:
	if GameManager.current_map == "cibiru":
		map = preload("res://Scenes/Levels/cibiru.tscn")
	if GameManager.current_map == "stage1_1":
		map = preload("res://Scenes/Levels/Forest/Stage1/stage1_1.tscn")
		notCibiru()

func instantiateMap() -> void:
	var mapInstance = map.instantiate()
	add_child(mapInstance)
	mapInstance.z_index = -1
	mapInstance.position = $MapDefaultPos.position
	if GameManager.current_map == "cibiru":
		music = $Cibiru/TownMusic
	if GameManager.current_map == "stage1_1":
		music = $Forest_Stage1_1/TownMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playFadeIn()
	initiateDefaultAnims()
	preloadMap()
	instantiateMap()
	showLevel()
	if GameManager.is_new == true:
		playOpeningCutscene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameManager.is_battle and music.is_playing():
		music.stop()
	if !GameManager.is_battle and !music.is_playing():
		music.play()

func _on_move_timer_timeout() -> void:
	$PlayerAmbatekkom.is_moving = false
	$PlayerAmbatekkom/DialogBox.visible = true
	$PlayerAmbatekkom/DialogBox.showTexts(iterator)
	$OpeningCutscene/AnimationPlayer.play("dialog_scale_up")
	$OpeningCutscene/MoveTimer.stop()

func _on_cinematic_screen_timer_timeout() -> void:
	$Control/CanvasLayer.visible = true
	$CanvasLayer/CinematicScreen/CinematicScreenTimer.stop()
	$CanvasLayer.visible = false

func _on_pause_button_pressed() -> void:
	$Control/CanvasLayer/PauseMenu.visible = true
	get_tree().paused = true

func _on_resume_button_pressed() -> void:
	$Control/CanvasLayer/PauseMenu.visible = false
	get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file.bind("res://Scenes/MainMenu/main_menu.tscn").call_deferred()

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	initiateDefaultAnims()

func _on_npc_pedagang1_body_entered(body: Node2D) -> void:
	$NPC_Pedagang1/AnimationPlayer.play("button_scale_up")

func _on_npc_pedagang1_body_exited(body: Node2D) -> void:
	$NPC_Pedagang1/AnimationPlayer.play("button_scale_down")

func _on_npc_cewek_body_entered(body: Node2D) -> void:
	$NPC_Cewek/AnimationPlayer.play("button_scale_up")

func _on_npc_cewek_body_exited(body: Node2D) -> void:
	$NPC_Cewek/AnimationPlayer.play("button_scale_down")

func _on_npc_pedagang1_button_pressed() -> void:
	pass

func _on_npc_cewek_button_pressed() -> void:
	$PlayerAmbatekkom.is_input_locked = true
	$NPC_Cewek/InteractButton.visible = false
	$CameraAnim.play("zoom_in")
	$NPC_Cewek/AnimationPlayer.play("dialog_scale_up")
	$CanvasLayer.visible = true
	playCinematicScreen()

func _on_npc_cewek_dialog_box_pressed() -> void:
	iterator += 1
	match iterator:
		2:
			$NPC_Cewek/DialogBox/Text1.visible = false
			$NPC_Cewek/DialogBox/Text2.visible = true
		3:
			$CameraAnim.play("pan_to_portal")
		4:
			$PlayerAmbatekkom.is_input_locked = false
			$CameraAnim.play("zoom_out")
			$NPC_Cewek/AnimationPlayer.play("dialog_scale_down")
			$CanvasLayer/CinematicScreen/Screen/AnimationPlayer.play("curtains_out")
			$CanvasLayer/CinematicScreen/CinematicScreenTimer.start()
			iterator = 1

func _on_portal_body_entered(body: Node2D) -> void:
	GameManager.current_map = "stage1_1"
	GameManager.is_new = false
	Data.save("user://player_data.json")
	get_tree().change_scene_to_file("res://Scenes/Cutscene/teleport/teleport_cutscene.tscn")

func _on_player_box1_pressed() -> void:
	if iterator == 6:
		iterator = 1
		$PlayerAmbatekkom.is_input_locked = false
		$OpeningCutscene/AnimationPlayer.play("RESET")
		$OpeningCutscene/AnimationPlayer.play("dialog_scale_down")
		$CanvasLayer/CinematicScreen/Screen/AnimationPlayer.play("curtains_out")
		$CanvasLayer/CinematicScreen/CinematicScreenTimer.start()
	else:
		iterator += 1
		$PlayerAmbatekkom/DialogBox.showTexts(iterator)
