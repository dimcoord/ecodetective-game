extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cutscene/TextBox/AnimationPlayer.play("tpyewriter")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_yes_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Cutscene/opening/opening_cutscene.tscn")


func _on_no_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")