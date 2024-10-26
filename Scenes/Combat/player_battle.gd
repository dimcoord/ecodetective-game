extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var base_attack = GameManager.base_attack
@onready var hp_bar = $Status/HealthBar
@onready var shield = $Shield

@export var max_hp = 25

var this_turn_attack = base_attack
var hp = 25
var is_alive = true

var user_data = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get user data from save data.
	user_data = Data.load_json_file("user://player_data.json")
	
	# Replace placeholder label with username.
	$Status/Label.text = user_data["username"]
	
	SignalManager.connect("player_hp_changed", on_player_hp_changed)
	hp = max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = max_hp
	is_alive = true
	
	$Status/Level.text = "Lv. %d" % GameManager.level
	
	shield.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp <= 0 and is_alive:
		print("player is dead")
		SignalManager.emit_signal("player_dead")
		is_alive = false
	else:
		is_alive = true

func on_player_hp_changed(new_hp):
	hp -= new_hp
	hp_bar.value = hp

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "block"):
		shield.visible = false
	SignalManager.player_animation_finished.emit(anim_name)


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if (anim_name == "hit"):
		SignalManager.hit.emit()
