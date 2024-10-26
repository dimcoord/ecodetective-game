extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

# Player variables
@export var speed = 40
@export var max_speed = 100
@export var FRICTION: float = 0.15
@export var move_direction = Vector2.ZERO
@export var is_input_locked = false
@export var is_moving = false
var is_alive = true

# Battle variables
var battle_scene = preload("res://Scenes/Combat/combat.tscn")

func _ready():
	SignalManager.connect("instantiate_battle", battle)
	pass

func _process(delta):
	get_input()

func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
	if !GameManager.is_battle && is_moving:
		move()
	
func get_input():
	if GameManager.is_battle:
		move_direction = Vector2.ZERO
	else:
		if is_moving == true:
			anim_state.travel("Walk")
			#print("player walk")
		else:
			anim_state.travel("Idle")
			#print("player swalk")
			
		# Movement
		if Input.is_action_pressed("ui_down") && !is_input_locked:
			move_direction = Vector2.DOWN
			is_moving = true
		elif Input.is_action_pressed("ui_up") && !is_input_locked:
			move_direction = Vector2.UP
			is_moving = true
		elif Input.is_action_pressed("ui_left") && !is_input_locked:
			move_direction = Vector2.LEFT
			is_moving = true
		elif Input.is_action_pressed("ui_right") && !is_input_locked:
			move_direction = Vector2.RIGHT
			is_moving = true

		# Idle animations
		if Input.is_action_just_released("ui_down") && !is_input_locked:
			is_moving = false
		if Input.is_action_just_released("ui_up") && !is_input_locked:
			is_moving = false
		if Input.is_action_just_released("ui_left") && !is_input_locked:
			is_moving = false
		if Input.is_action_just_released("ui_right") && !is_input_locked:
			is_moving = false
			
		# Set animations direction
		anim_tree.set("parameters/Idle/blend_position", move_direction)
		anim_tree.set("parameters/Walk/blend_position", move_direction)
		anim_tree.set("parameters/Turn/blend_position", move_direction)
		
func move():
	move_direction = move_direction.normalized()
	velocity += move_direction * 40 
	velocity = velocity.limit_length(max_speed)
	move_and_slide()
		
func battle(monster_code):
	# Inisiate battle scene
	GameManager.is_battle = true
	var battle_instance = battle_scene.instantiate()
	battle_instance.monster_code = monster_code
	add_child(battle_instance)

# TOUCH CONTROL
# Nyalain "Emulate Touch to Mouse" di Project Settings
# Nanti pas build mah diumpetin biar mobile-only

func _on_top_pressed() -> void:
	if !is_input_locked:
		move_direction = Vector2.UP
		is_moving = true

func _on_top_released() -> void:
	if !is_input_locked:
		is_moving = false

func _on_right_pressed() -> void:
	if !is_input_locked:
		move_direction = Vector2.RIGHT
		is_moving = true

func _on_right_released() -> void:
	if !is_input_locked:
		is_moving = false

func _on_left_pressed() -> void:
	if !is_input_locked:
		move_direction = Vector2.LEFT
		is_moving = true

func _on_left_released() -> void:
	if !is_input_locked:
		is_moving = false

func _on_bottom_pressed() -> void:
	if !is_input_locked:
		move_direction = Vector2.DOWN
		is_moving = true

func _on_bottom_released() -> void:
	if !is_input_locked:
		is_moving = false
