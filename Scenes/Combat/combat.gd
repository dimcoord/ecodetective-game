extends Control

@onready var canvas = $CanvasLayer
@onready var anim = $CanvasLayer/FadeTransition
@onready var player = $CanvasLayer/Player
@onready var monster = $CanvasLayer/Monster
@onready var menu_animation = $CanvasLayer/Menu/MenuAnimation
@onready var menu = $CanvasLayer/CombatMenu

var monster_code = "m_iyk"

var playerBlocked = false

var item_attribute: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initiate_signal()
	
	$CanvasLayer/CombatResult.visible = false
	
	$Music.play()
	
	anim.play("fade_in")

func _initiate_signal():
	SignalManager.connect("player_attack", on_attack_button_pressed)
	SignalManager.connect("player_block", on_block_button_pressed)
	SignalManager.connect("monster_dead", on_monster_dead)
	SignalManager.connect("player_dead", on_player_dead)
	SignalManager.connect("player_animation_finished", on_player_animation_finished)
	SignalManager.connect("monster_animation_finished", on_monster_animation_finished)
	SignalManager.connect("player_use_item", on_player_use_item)
	SignalManager.connect("hit", on_hit)
	SignalManager.connect("win_combat", win)
	SignalManager.connect("exit_combat", exit_combat)

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
	await get_tree().create_timer(0.5).timeout
	
	$Music.volume_db = -8.412
	$CanvasLayer/Fade.visible = true
	anim.play("combat_result_fade")
	
	await get_tree().create_timer(1.0).timeout
	
	# Show combat result
	$CanvasLayer/CombatResult.visible = true
	$CanvasLayer/CombatResult/AnimationPlayer.play("show")
	
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
	elif (anim_name == "normal_attack" || anim_name == "special_attack"):
		if (anim_name == "special_attack"):
			var effect_scene = load(item_attribute["attack_effect_path"])
			var effect_instance = effect_scene.instantiate()
			canvas.add_child(effect_instance)
			effect_instance.position = $CanvasLayer/FXE_pos.position	
			await get_tree().create_timer(1.0).timeout 
		
		monster.animation_player.play("hit")
		await get_tree().create_timer(1.0).timeout 
		SignalManager.monster_hp_changed.emit(player.this_turn_attack)
		await get_tree().create_timer(1.0).timeout
		on_monster_turn()
	elif (anim_name == "block"):
		on_player_turn()
	
func on_monster_animation_finished():
	# If player not block
	if !playerBlocked:
		var effect_scene = load(monster.monster_attribute["attack_effect_path"])
		var effect_instance = effect_scene.instantiate()
		canvas.add_child(effect_instance)
		effect_instance.position = $CanvasLayer/FX_pos.position	

		await get_tree().create_timer(1.0).timeout 
		
		player.animation_player.play("hit")
		await get_tree().create_timer(1.0).timeout
		SignalManager.player_hp_changed.emit(monster.base_attack)
	else:
		player.shield.visible = true
		player.animation_player.play("block")
		await get_tree().create_timer(1.0).timeout

func _on_fade_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		GameManager.is_battle = false
		queue_free()
		
func on_player_use_item(item_id: String):
	item_attribute = Data.search_from_dictionary(Data.items["data"], item_id, "code")
	
	# Update attack damage for this turn.
	player.this_turn_attack = item_attribute["damage"]
	
	menu_animation.play("hide")
	player.animation_player.play("special_attack")
	
func on_hit():
	$CanvasLayer/AttackSound.play()

func win():
	GameManager.win_combat(monster.monster_attribute["is_boss"])

func exit_combat():
	anim.play("fade_out")
