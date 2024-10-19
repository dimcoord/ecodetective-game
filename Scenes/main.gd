extends Node2D

@onready var forest_music = $Music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	forest_music.play()
	$FadeTransition.visible = true
	$FadeTransition/AnimationPlayer.play("fade_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Control music playing.
	if GameManager.is_battle and forest_music.is_playing():
		forest_music.stop()
	
	if !GameManager.is_battle and !forest_music.is_playing():
		forest_music.play()
