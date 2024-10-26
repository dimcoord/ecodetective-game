extends Node2D

@onready var base_attack = 4
@onready var hp_bar = $Status/HealthBar
@onready var text_damage_animation = $TeksDamageAnimation
@onready var text_damage = $TextDamage
@export var max_hp = 25

var animation_scene: PackedScene
var animation_player: AnimationPlayer

var monster_attribute: Dictionary = {}

var hp = 25
var is_alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.connect("monster_hp_changed", on_enemy_hp_changed)
	
	_initiate_attributes()
	
	initiate_monster_animationn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hp <= 0 and is_alive:
		SignalManager.emit_signal("monster_dead")
		print("monster dead")
		is_alive = false
		
func _initiate_attributes():
	var monster_code = get_parent().get_parent().monster_code
	monster_attribute = Data.search_from_dictionary(Data.monsters["data"], monster_code, "monster_code")
		
	$Status/MonsterName.text = monster_attribute["name"]
	max_hp = monster_attribute["max_hp"]
	hp = max_hp
	hp_bar.max_value = max_hp
	hp_bar.value = max_hp
	base_attack = monster_attribute["base_attack"]
	
func initiate_monster_animationn():
	if ($Sprite2D || $AnimationPlayer):
		$Sprite2D	.queue_free()
		$AnimationPlayer.queue_free()
		
	animation_scene = load(monster_attribute["tscn_combat_path"])
	var anim_instance = animation_scene.instantiate()
	add_child(anim_instance)
	print(get_tree_string())
	
	animation_player = anim_instance.get_node("AnimationPlayer")

func on_enemy_hp_changed(new_hp):
	hp -= new_hp
	hp_bar.value = hp
