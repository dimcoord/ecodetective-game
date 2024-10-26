extends CharacterBody2D

# Monster Attributes
# Monster ID: Should registered in monsters.json
@export var monster_code = "m_sjg"
var animation_scene: PackedScene

var animation_player
var animated_sprite

# Monster Stats
var monster_attribute = {}
var FRICTION: float = 0.15

# Monster States
var is_alive = true
var move_direction = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var dir = [Vector2.RIGHT, Vector2.LEFT,Vector2.UP, Vector2.DOWN]

func _ready() -> void:
	initiate_monster_animationn()

func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move()
	move_and_slide()

func _process(delta):
	if move_direction == Vector2.UP:
		animation_player.play("up")
		animated_sprite.flip_h = false
	elif move_direction == Vector2.DOWN:
		animation_player.play("down")
		animated_sprite.flip_h = false
	elif move_direction == Vector2.LEFT:
		animation_player.play("left")
		animated_sprite.flip_h = false
	elif move_direction == Vector2.RIGHT:
		animation_player.play("right")
		animated_sprite.flip_h = false
		
func initiate_monster_animationn():
	if ($AnimatedSprite2D || $AnimationPlayer):
		$AnimatedSprite2D	.queue_free()
		$AnimationPlayer.queue_free()
		
	monster_attribute = Data.search_from_dictionary(Data.monsters["data"], monster_code, "monster_code")
	animation_scene = load(monster_attribute["tscn_path"])
	var anim_instance = animation_scene.instantiate()
	add_child(anim_instance)
	
	animation_player = anim_instance.get_node("AnimationPlayer")
	animated_sprite = anim_instance.get_node("AnimatedSprite2D")

func move():
	move_direction = move_direction.normalized()
	
	if !GameManager.is_battle:
		velocity += move_direction * monster_attribute["movement_speed"]
		velocity = velocity.limit_length(monster_attribute["max_movement_speed"])
	else:
		velocity = Vector2.ZERO

func _on_change_direction_timer_timeout():
	# change direction on timer time out
	var rnd_num = rng.randi_range(0, 3)
	move_direction = dir[rnd_num]

func _on_hit_box_body_entered(body):
	if !body.is_in_group("player"):
		# change direction on collision with objects
		var rnd_num = rng.randi_range(0, 3)
		move_direction = dir[rnd_num]
	else:
		SignalManager.instantiate_battle.emit(monster_code)
		queue_free()
