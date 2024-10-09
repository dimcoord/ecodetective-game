extends Node2D

@onready var world_music = $TownMusic

func _ready():
	$FadeTransition/AnimationPlayer.play("fade_out")

func _process(delta):
	# Control playing music.
	if GameManager.is_battle and world_music.is_playing():
		world_music.stop()
	if !GameManager.is_battle and !world_music.is_playing():
		world_music.play()
