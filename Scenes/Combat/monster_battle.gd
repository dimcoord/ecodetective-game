extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var base_attack = 4
@onready var hp_bar = $Status/HealthBar

@export var max_hp = 25

var this_turn_attack = base_attack
var hp = 25
var is_alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("monster_hp_changed", on_enemy_hp_changed)
	hp = max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = max_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp <= 0 and is_alive:
		SignalManager.emit_signal("monster_dead")
		print("monster dead")
		is_alive = false

func on_enemy_hp_changed(new_hp):
	hp -= new_hp
	hp_bar.value = hp


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "attack"):
		SignalManager.monster_animation_finished.emit()
