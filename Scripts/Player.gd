extends CharacterBody2D

# Movement
var speed := 500
var jump_velocity = -500
var gravity := 1000

# Dash
var dash_speed := 10000
var dash_time := 0.2
var can_dash := false

# For creature mimic
var movement_history: Array[Vector2] = []
@export var max_history_length := 3000

# Animation
@onready var anim: AnimatedSprite2D = $player_animation
@onready var smoke_anim: AnimatedSprite2D = $Smoke
func _ready():
	$Smoke.hide()
func _physics_process(delta):
	# Dash (air dash only)
	if is_on_floor():
		can_dash = false

	# Horizontal movement
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		anim.flip_h = false
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
		anim.flip_h = true
	else:
		velocity.x = 0

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		can_dash = true

	# Gravity
	velocity.y += gravity * delta

	# Dash
	if Input.is_action_just_pressed("dash") and can_dash:
		dash()

	# Move the character
	move_and_slide()

	# --- Record position each frame ---
	movement_history.append(global_position)
	if movement_history.size() > max_history_length:
		movement_history.pop_front()

	# --- Animation Logic ---
	update_animation()


func dash():
	can_dash = false

	# Match smoke flip with player direction
	smoke_anim.flip_h = anim.flip_h

	# Position the smoke slightly behind depending on direction
	var offset_x = 65 if anim.flip_h else -65
	smoke_anim.global_position = global_position + Vector2(offset_x, 10)

	# Show and play smoke animation
	$Smoke.show()
	smoke_anim.play("Smoke")

	# Perform dash movement
	velocity.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * dash_speed
	velocity.y = 0
	move_and_slide()

	await get_tree().create_timer(dash_time).timeout

func update_animation():
	if not is_on_floor():
		anim.play("Jumping")
	elif abs(velocity.x) > 0:
		anim.play("Walking")
	else:
		anim.play("Idle")
