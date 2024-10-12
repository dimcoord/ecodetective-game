extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

# Player variables
@export var speed = 40
@export var max_speed = 100
@export var FRICTION: float = 0.15
var is_alive = true
var move_direction = Vector2.ZERO
var is_moving = false

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
		if Input.is_action_pressed("ui_down"):
			move_direction = Vector2.DOWN
			is_moving = true
		elif Input.is_action_pressed("ui_up"):
			move_direction = Vector2.UP
			is_moving = true
		elif Input.is_action_pressed("ui_left"):
			move_direction = Vector2.LEFT
			is_moving = true
		elif Input.is_action_pressed("ui_right"):
			move_direction = Vector2.RIGHT
			is_moving = true

		# Idle animations
		if Input.is_action_just_released("ui_down"):
			is_moving = false
		if Input.is_action_just_released("ui_up"):
			is_moving = false
		if Input.is_action_just_released("ui_left"):
			is_moving = false
		if Input.is_action_just_released("ui_right"):
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
		
func battle():
	# Inisiate battle scene
	GameManager.is_battle = true
	var battle_instance = battle_scene.instantiate()
	add_child(battle_instance)
	
	
