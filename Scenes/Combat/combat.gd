extends Control

@onready var anim = $CanvasLayer/FadeTransition
@onready var player = $CanvasLayer/Player
@onready var monster = $CanvasLayer/Monster
@onready var menu_animation = $CanvasLayer/Menu/MenuAnimation
@onready var menu = $CanvasLayer/CombatMenu

var playerBlocked = false

func _initiate_signal():
	SignalManager.connect("player_attack", on_attack_button_pressed)
	SignalManager.connect("player_block", on_block_button_pressed)
	SignalManager.connect("monster_dead", on_monster_dead)
	SignalManager.connect("player_dead", on_player_dead)
	SignalManager.connect("player_animation_finished", on_player_animation_finished)
	SignalManager.connect("monster_animation_finished", on_monster_animation_finished)
	SignalManager.connect("player_use_item", on_player_use_item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initiate_signal()
	
	$Music.play()
	
	anim.play("fade_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_attack_button_pressed() -> void:
	# Reset attack damage to base.
	player.this_turn_attack = player.base_attack
	
	menu_animation.play("hide")
	player.animation_player.play("normal_attack")
	
func on_block_button_pressed() -> void:
	menu_animation.play("hide")
	playerBlocked = true
	on_monster_turn()
	
func on_monster_dead():
	# Exit battle
	print("curut na paeh")
	anim.play("fade_out")
	
func on_player_dead():
	# Exit battle
	GameManager.game_over = true
	anim.play("fade_out")

func on_monster_turn():
	if monster.hp > 0:
		monster.animation_player.play("attack")
		
func on_player_turn():
	playerBlocked = false
	if (player.hp > 0):
		menu_animation.play("show")
	
func on_player_animation_finished(anim_name):
	if (anim_name == "hit"):
		on_player_turn()
	elif (anim_name == "normal_attack"):
		monster.animation_player.play("hit")
		await get_tree().create_timer(1.0).timeout 
		SignalManager.monster_hp_changed.emit(player.this_turn_attack)
		await get_tree().create_timer(1.0).timeout
		on_monster_turn()
	elif (anim_name == "block"):
		on_player_turn()
	
func on_monster_animation_finished():
	if !playerBlocked:
		player.animation_player.play("hit")
		await get_tree().create_timer(1.0).timeout
		SignalManager.player_hp_changed.emit(4)
	else:
		player.shield.visible = true
		player.animation_player.play("block")
		await get_tree().create_timer(1.0).timeout

func _on_fade_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		GameManager.is_battle = false
		queue_free()
		
func on_player_use_item(item_id: String):
	var item_attributes = Data.search_from_dictionary(Data.items["data"], item_id)
	
	# Update attack damage for this turn.
	player.this_turn_attack = item_attributes["damage"]
	
	menu_animation.play("hide")
	player.animation_player.play("normal_attack")
