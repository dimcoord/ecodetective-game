extends Node2D

var save_path := "user://player_data.json"
var text1 = 0
var text2 = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cutscene/TextBox/AnimationPlayer.play("tpyewriter")
	#$Cutscene/Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Cutscene/TextBox/Text1.visible == true:
		if text1 != $Cutscene/TextBox/Text1.visible_characters:
			text1 = $Cutscene/TextBox/Text1.visible_characters
			$Cutscene/TextBox/TypingSound.play()
	if $Cutscene/TextBox/Text2.visible == true:
		if text2 != $Cutscene/TextBox/Text1.visible_characters:
			text2 = $Cutscene/TextBox/Text1.visible_characters
			$Cutscene/TextBox/TypingSound.play()

func save() -> void:
	var save_dict := {
		"pos_x" : 0, # gak support Vector2
		"pos_y" : 0, # gak support Vector2
		"username" : $Cutscene/TextBox/LineEdit.text,
		"current_hp" : 100,
		"max_hp" : 100,
		"exp": 0,
		"is_alive" : true,
		"items_obtained": [
			"i_fire_extinguisher"
		],
	}
	var json_string := JSON.stringify(save_dict)
	var file_access := FileAccess.open(save_path, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
	file_access.store_line(json_string)
	file_access.close()

func _on_line_edit_text_submitted(new_text: String) -> void:
	save()
	get_tree().change_scene_to_file("res://Scenes/Cutscene/teleport/teleport_cutscene.tscn")
