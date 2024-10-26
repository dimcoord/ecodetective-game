extends Node2D

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.play("idle")
	if (anim_name == "attack"):
		SignalManager.monster_animation_finished.emit()


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if (anim_name == "hit"):
		SignalManager.hit.emit()
		get_parent().text_damage_animation.play("text_damage")
