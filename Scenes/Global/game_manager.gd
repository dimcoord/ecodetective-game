extends Node2D

var save_file
var pos_x: int = 0
var pos_y: int = 0
var username = null
var current_map: String = "cibiru"
var current_hp: int = 100
var max_hp: int = 100
var exp: int = 0
var level: int = 0
var total_move: int = 0
var turn: String = "player"
var is_alive: bool = true
var is_battle: bool = false
var is_dialog: bool = false
var is_new: bool = true
var game_over: bool = false
var base_attack: int = 10

func _ready():
	levelUp()
	save_file = Data.load_json_file("user://player_data.json")
	if save_file:
		pos_x = save_file.get("pos_x")
		pos_y = save_file.get("pos_y")
		username = save_file.get("username")
		current_map = save_file.get("current_map")
		current_hp = save_file.get("current_hp")
		max_hp = save_file.get("max_hp")
		exp = save_file.get("exp")
		level = save_file.get("level")
		total_move = save_file.get("total_move")
		is_new = save_file.get("is_new")
		base_attack = save_file.get("base_attack")

func levelUp() -> void:
	level += 1
	exp = 0
	base_attack += level + 1
	max_hp += 5
	
func _gains_exp(exp_gained: int):
	exp += exp
		
func win_combat(is_boss: bool):
	if is_boss:
		exp += 100
	else:
		exp += 20
		
