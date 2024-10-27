extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ContainerBox/Node2D.visible = false
	$ContainerBox/Node2D/Level.text = "Lv. %d" % GameManager.level
	$ContainerBox/Node2D/TextureProgressBar.value = GameManager.exp

func set_exp_value():
	var animation: Animation = $AnimationPlayer.get_animation("gains_exp")
	var currentValue = $ContainerBox/Node2D/TextureProgressBar.value
	
	# Gains exp
	SignalManager.win_combat.emit()
   
	animation.track_set_key_value(animation.find_track("ContainerBox/Node2D/TextureProgressBar:value", 0), 0, currentValue)
	animation.track_set_key_value(animation.find_track("ContainerBox/Node2D/TextureProgressBar:value", 0), 1, GameManager.exp)
	
	$ProgressSound.play()
	$AnimationPlayer.play("gains_exp")
	
func player_level_up():
	GameManager.levelUp()
	
	var animation: Animation = $AnimationPlayer.get_animation("level_up")
	
	var before_level_up = $ContainerBox/Node2D/Level.text
	var after_level_up =  "Lv. %d" % GameManager.level
	
	animation.track_set_key_value(animation.find_track("ContainerBox/Node2D/Level:text", 0), 0, before_level_up)
	animation.track_set_key_value(animation.find_track("ContainerBox/Node2D/Level:text", 0), 1, after_level_up)
	
	$LevelUpSound.play()
	$AnimationPlayer.play("level_up")
	
func combat_result_finished():
	await get_tree().create_timer(0.5).timeout
		
	$ContainerBox/Node2D.visible = false
	$AnimationPlayer.play("hide")
	await get_tree().create_timer(1).timeout
		
	SignalManager.exit_combat.emit()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show":
		$ContainerBox/Node2D.visible = true
		set_exp_value()
	elif anim_name == "gains_exp":
		$ProgressSound.stop()
		if GameManager.exp >= 100:
			$ContainerBox/Node2D/TextureProgressBar.value = 0
			player_level_up()
			
		await get_tree().create_timer(2.0).timeout
			
		combat_result_finished()
