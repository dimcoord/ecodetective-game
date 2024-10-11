extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FadeTransition.visible = true
	$FadeTransition/FadeTimer.start()
	$FadeTransition/AnimationPlayer.play("fade_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_fade_timer_timeout() -> void:
	$FadeTransition.visible = false
