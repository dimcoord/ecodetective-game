extends NinePatchRect

var helpIterator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_help_left_button_pressed() -> void:
	if helpIterator == 0:
		return
	else:
		helpIterator -= 1

func _on_help_right_button_pressed() -> void:
	if helpIterator == 9:
		return
	else:
		helpIterator += 1

func _on_help_exit_button_pressed() -> void:
	$Control/CanvasLayer/HelpMenu.visible = false
	get_tree().paused = false
