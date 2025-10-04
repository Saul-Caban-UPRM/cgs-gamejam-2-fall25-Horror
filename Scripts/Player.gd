extends CharacterBody2D

# Movement
var speed := 500
var jump_velocity = -500
var gravity := 1000

# Dash
var dash_speed := 10000
var dash_time := 0.2
var can_dash := false  # Dash becomes available only after jump

func _physics_process(delta):
	# Dash (air dash only)
	if is_on_floor():
		can_dash = false
	# Horizontal movement
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
	else:
		velocity.x = 0

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		can_dash = true  # Enable dash after jumping

	# Gravity
	velocity.y += gravity * delta

	# Dash (air dash only)
	if Input.is_action_just_pressed("dash") and can_dash:
		dash()
	# Move the character
	move_and_slide()

func dash():
	can_dash = false  # Consume the dash
	velocity.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * dash_speed
	velocity.y = 0
	move_and_slide()
	await get_tree().create_timer(dash_time).timeout
