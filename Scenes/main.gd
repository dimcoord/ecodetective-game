extends Node2D

@onready var music = $DetectiveMusic
var iterator = 0
var map
var mapInstance

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
	showTexts("player")
	$OpeningCutscene/MoveTimer.start()

func initiateDefaultAnims() -> void:
	$OpeningCutscene/AnimationPlayer.play("RESET")
	$NPC_Cewek/AnimationPlayer.play("RESET")
	$Portal.play("default")
	$NPC_Cewek/Area2D/InteractBody.disabled = true
	if GameManager.is_new == true:
		$NPC_Cewek/Area2D/InteractBody.disabled = false
		$Portal/Area2D/CollisionShape2D.disabled = true
	$Control/CanvasLayer/PauseMenu.visible = false

func flushNPC() -> void:
	$NPC_Cewek.queue_free()
	$NPC_Pedagang1.queue_free()
	$StaticBody2D.queue_free()

func showNPC() -> void:
	match GameManager.current_map:
		"cibiru":
			pass
		"stage1_1":
			flushNPC()

func preloadMap() -> void:
	if GameManager.current_map == "cibiru":
		map = preload("res://Scenes/Levels/cibiru.tscn")
	elif GameManager.current_map == "stage1_1":
		if GameManager.total_move <= 10:
			map = preload("res://Scenes/Levels/Forest/Stage1/stage1_1.tscn")
		elif GameManager.total_move <= 20:
			map = preload("res://Scenes/Levels/Forest/Stage1/stage2_1.tscn")
		elif GameManager.total_move <= 30:
			map = preload("res://Scenes/Levels/Forest/Stage1/stage3_1.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/Cutscene/ending/bad/game_over.tscn")
		$Portal.visible = true
		$Portal.position = Vector2(500, 30)
		#$Portal/Area2D/CollisionShape2D.disabled = false
	else:
		if GameManager.total_move <= 10:
			map = preload("res://Scenes/Levels/Forest/Full/forest.tscn")
		elif GameManager.total_move <= 20:
			map = preload("res://Scenes/Levels/Forest/Full/forest_2.tscn")
		elif GameManager.total_move <= 30:
			map = preload("res://Scenes/Levels/Forest/Full/forest_3.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/Cutscene/ending/bad/game_over.tscn")
		$Portal.visible = false
		$Portal/Area2D/CollisionShape2D.disabled = true

func defineTeleportPoints() -> void:
	$TeleportPoints/LeftArea.position = $MapDefaultPos/ForestPos/LeftArea.position
	$TeleportPoints/RightArea.position = $MapDefaultPos/ForestPos/RightArea.position
	$TeleportPoints/TopArea.position = $MapDefaultPos/ForestPos/TopArea.position
	$TeleportPoints/BottomArea.position = $MapDefaultPos/ForestPos/BottomArea.position

func instantiateMap() -> void:
	print(GameManager.total_move)
	mapInstance = map.instantiate()
	add_child(mapInstance)
	mapInstance.z_index = -1
	match GameManager.current_map:
		"cibiru":
			if GameManager.is_new == false:
				$PlayerAmbatekkom.position = $PlayerDefaultPos/CibiruPos.position
				Data.save()
			$PlayerAmbatekkom/Camera.top_left = $PlayerAmbatekkom/Camera/Limits/Cibiru/TopLeft
			$PlayerAmbatekkom/Camera.bottom_right = $PlayerAmbatekkom/Camera/Limits/Cibiru/BottomRight
			mapInstance.position = $MapDefaultPos/CibiruPos.position
		"stage1_1":
			$MapDefaultPos/ForestPos/LeftArea.position = Vector2(0, 30)
			$MapDefaultPos/ForestPos/RightArea.position = Vector2(615, -155)
			$MapDefaultPos/ForestPos/TopArea.position = Vector2(1000, 1000)
			$MapDefaultPos/ForestPos/BottomArea.position = Vector2(263, 275)
			mapInstance.position = $MapDefaultPos/ForestPos.position
			$PlayerAmbatekkom.position = $PlayerDefaultPos/ForestPos.position
		"stage1_2":
			$MapDefaultPos/ForestPos/LeftArea.position = Vector2(1000, 1000)
			$MapDefaultPos/ForestPos/RightArea.position = Vector2(600, 54)
			$MapDefaultPos/ForestPos/TopArea.position = Vector2(1000, 1000)
			$MapDefaultPos/ForestPos/BottomArea.position = Vector2(263, 275)
			mapInstance.position = $MapDefaultPos/ForestFullPos/ForestFullPos1.position
		"stage1_3":
			$MapDefaultPos/ForestPos/LeftArea.position = Vector2(1000, 1000)
			$MapDefaultPos/ForestPos/RightArea.position = Vector2(1000, 1000)
			$MapDefaultPos/ForestPos/TopArea.position = Vector2(255, 24)
			$MapDefaultPos/ForestPos/BottomArea.position = Vector2(1000, 1000)
			mapInstance.position = $MapDefaultPos/ForestFullPos/ForestFullPos2.position
		"stage1_4":
			$MapDefaultPos/ForestPos/LeftArea.position = Vector2(3, 58)
			$MapDefaultPos/ForestPos/RightArea.position = Vector2(1000, 1000)
			$MapDefaultPos/ForestPos/TopArea.position = Vector2(1000, 1000)
			$MapDefaultPos/ForestPos/BottomArea.position = Vector2(1000, 1000)
			mapInstance.position = $MapDefaultPos/ForestFullPos/ForestFullPos3.position
		"stage1_5":
			$MapDefaultPos/ForestPos/LeftArea.position = Vector2(0, 10)
			$MapDefaultPos/ForestPos/RightArea.position = Vector2(1000, 1000)
			$MapDefaultPos/ForestPos/TopArea.position = Vector2(246, 1)
			$MapDefaultPos/ForestPos/BottomArea.position = Vector2(1000, 1000)
			mapInstance.position = $MapDefaultPos/ForestFullPos/ForestFullPos4.position
	defineTeleportPoints()

func showTexts(whichCharacter: String):
	var dialog
	if whichCharacter == "cewek":
		dialog = $NPC_Cewek/DialogBox.get_children()
	elif whichCharacter == "player":
		dialog = $PlayerAmbatekkom/DialogBox.get_children()
	for i in range(len(dialog)):
		dialog[i].visible = false
	dialog[iterator].visible = true
	print(iterator)
		
func update_level_status():
	$Control/CanvasLayer/LevelText/PlayerLevel.text = str(GameManager.level)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("exit_combat", update_level_status)
	playFadeIn()
	initiateDefaultAnims()
	preloadMap()
	instantiateMap()
	showNPC()
	showLevel()
	if GameManager.is_new == true:
		playOpeningCutscene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameManager.is_battle and music.is_playing():
		music.stop()
	if !GameManager.is_battle and !music.is_playing():
		music.play()
	print($PlayerAmbatekkom.position)

func _on_move_timer_timeout() -> void:
	$PlayerAmbatekkom.is_moving = false
	$PlayerAmbatekkom/DialogBox.visible = true
	$OpeningCutscene/AnimationPlayer.play("dialog_scale_up")
	$OpeningCutscene/MoveTimer.stop()

func _on_player_box1_pressed() -> void:
	var dialog = $PlayerAmbatekkom/DialogBox.get_children()
	if iterator == (len(dialog) - 1):
		$PlayerAmbatekkom.is_input_locked = false
		$OpeningCutscene/AnimationPlayer.play("dialog_scale_down")
		$CanvasLayer/CinematicScreen/Screen/AnimationPlayer.play("curtains_out")
		$CanvasLayer/CinematicScreen/CinematicScreenTimer.start()
		iterator = 0
	else:
		iterator += 1
		showTexts("player")

func _on_cinematic_screen_timer_timeout() -> void:
	$Control/CanvasLayer.visible = true
	$CanvasLayer/CinematicScreen/CinematicScreenTimer.stop()
	$CanvasLayer.visible = false
	$Portal/Area2D/CollisionShape2D.disabled = false

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

func _on_npc_cewek_body_entered(body: Node2D) -> void:
	$NPC_Cewek/AnimationPlayer.play("button_scale_up")

func _on_npc_cewek_body_exited(body: Node2D) -> void:
	$NPC_Cewek/AnimationPlayer.play("button_scale_down")

func _on_npc_cewek_button_pressed() -> void:
	$PlayerAmbatekkom.is_input_locked = true
	$NPC_Cewek/InteractButton.visible = false
	$PlayerAmbatekkom/Camera.offset = Vector2(-25, -75)
	$CameraAnim.play("zoom_in")
	$NPC_Cewek/AnimationPlayer.play("dialog_scale_up")
	$CanvasLayer.visible = true
	playCinematicScreen()
	showTexts("cewek")

func _on_npc_cewek_dialog_box_pressed() -> void:
	var dialog = $NPC_Cewek/DialogBox.get_children()
	if iterator == (len(dialog) - 1):
		$PlayerAmbatekkom.is_input_locked = false
		$CameraAnim.play("zoom_out")
		$NPC_Cewek/AnimationPlayer.play("dialog_scale_down")
		$CanvasLayer/CinematicScreen/Screen/AnimationPlayer.play("curtains_out")
		$CanvasLayer/CinematicScreen/CinematicScreenTimer.start()
		if GameManager.is_new == true:
			$CameraAnim.play("pan_to_portal")
		$PlayerAmbatekkom/Camera.offset = Vector2(0, 0)
		GameManager.is_new = false
		iterator = 0
	else:
		iterator += 1
		showTexts("cewek")

func _on_portal_body_entered(body: Node2D) -> void:
	if body == $PlayerAmbatekkom:
		if GameManager.current_map == "cibiru":
			GameManager.current_map = "stage1_1"
			get_tree().change_scene_to_file.bind("res://Scenes/Cutscene/teleport/teleport_cutscene.tscn").call_deferred()
		elif GameManager.current_map == "stage1_1":
			GameManager.current_map = "cibiru"
			Data.save()
			get_tree().change_scene_to_file.bind("res://Scenes/Cutscene/teleport/teleport_cutscene.tscn").call_deferred()

func _on_left_area_body_entered(body: Node2D) -> void:
	if body == $PlayerAmbatekkom:
		GameManager.total_move += 1
		if GameManager.current_map == "stage1_1":
			GameManager.current_map = "stage1_2"
			mapInstance.queue_free()
			preloadMap()
			instantiateMap()
			$PlayerAmbatekkom.position = $PlayerDefaultPos/ForestFullPos/ForestFullPos1.position
		if GameManager.current_map == "stage1_4":
			GameManager.current_map = "stage1_1"
			mapInstance.queue_free()
			preloadMap()
			instantiateMap()
			$PlayerAmbatekkom.position = $PlayerDefaultPos/ForestFullPos/ForestFullPos5.position
		$PlayerAmbatekkom/Camera.setLimits()
		print("go left")

func _on_right_area_body_entered(body: Node2D) -> void:
	if body == $PlayerAmbatekkom:
		GameManager.total_move += 1
		if GameManager.current_map == "stage1_1":
			GameManager.current_map = "stage1_4"
			mapInstance.queue_free()
			preloadMap()
			instantiateMap()
			$PlayerAmbatekkom.position = $PlayerDefaultPos/ForestFullPos/ForestFullPos6.position
		elif GameManager.current_map == "stage1_2":
			GameManager.current_map = "stage1_1"
			mapInstance.queue_free()
			preloadMap()
			instantiateMap()
			$PlayerAmbatekkom.position = $PlayerDefaultPos/ForestFullPos/ForestFullPos2.position
		if GameManager.current_map == "stage1_3":
			GameManager.current_map = "stage1_5"
			mapInstance.queue_free()
			preloadMap()
			instantiateMap()
			$PlayerAmbatekkom.position = $PlayerDefaultPos/ForestFullPos/ForestFullPos2.position
		$PlayerAmbatekkom/Camera.setLimits()
		print("go right")

func _on_top_area_body_entered(body: Node2D) -> void:
	if body == $PlayerAmbatekkom:
		GameManager.total_move += 1
		if GameManager.current_map == "stage1_3":
			GameManager.current_map = "stage1_1"
			mapInstance.queue_free()
			preloadMap()
			instantiateMap()
			$PlayerAmbatekkom.position = $PlayerDefaultPos/ForestFullPos/ForestFullPos3.position
		$PlayerAmbatekkom/Camera.setLimits()
		print("go up")

func _on_bottom_area_body_entered(body: Node2D) -> void:
	if body == $PlayerAmbatekkom:
		GameManager.total_move += 1
		if GameManager.current_map == "stage1_1":
			GameManager.current_map = "stage1_3"
			mapInstance.queue_free()
			preloadMap()
			instantiateMap()
			$PlayerAmbatekkom.position = $PlayerDefaultPos/ForestFullPos/ForestFullPos4.position
		$PlayerAmbatekkom/Camera.setLimits()
		print("go down")
