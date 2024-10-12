extends CharacterBody2D

# monster stats
@export var speed = 10
@export var max_speed = 30
@export var FRICTION: float = 0.15

var is_alive = true
var move_direction = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var dir = [Vector2.RIGHT, Vector2.LEFT,Vector2.UP, Vector2.DOWN]

func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	move()
	move_and_slide()

func _process(delta):
	if move_direction == Vector2.UP:
		$AnimationPlayer.play("up")
		$AnimatedSprite2D.flip_h = false
	elif move_direction == Vector2.DOWN:
		$AnimationPlayer.play("down")
		$AnimatedSprite2D.flip_h = false
	elif move_direction == Vector2.LEFT:
		$AnimationPlayer.play("left")
		$AnimatedSprite2D.flip_h = false
	elif move_direction == Vector2.RIGHT:
		$AnimationPlayer.play("right")
		$AnimatedSprite2D.flip_h = true

func move():
	
	move_direction = move_direction.normalized()
	
	if !GameManager.is_battle:
		velocity += move_direction * speed 
		velocity = velocity.limit_length(max_speed)
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
		SignalManager.instantiate_battle.emit()
		queue_free()
