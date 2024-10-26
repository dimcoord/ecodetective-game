extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cutscene/TextBox/AnimationPlayer.play("tpyewriter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	GameManager.username = $Cutscene/TextBox/LineEdit.text
	if GameManager.username:
		Data.save("user://player_data.json")
		get_tree().change_scene_to_file("res://Scenes/Cutscene/teleport/teleport_cutscene.tscn")
	else:
		pass
