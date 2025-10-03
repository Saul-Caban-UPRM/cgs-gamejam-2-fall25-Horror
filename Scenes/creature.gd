extends CharacterBody2D

@export var speed := 500
@export var jump_velocity := -400
@export var gravity := 1000
@export var dash_speed := 10000
@export var dash_time := 0.2
@export var delay_frames := 20 

var can_dash := false
var player: Node = null

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(delta):
	if not player or player.input_history.size() <= delay_frames:
		return

	var inputs = player.input_history[-delay_frames]

	# Reset horizontal movement
	if inputs["right"]:
		velocity.x = speed
	elif inputs["left"]:
		velocity.x = -speed
	else:
		velocity.x = 0

	# Jump
	if inputs["jump"] and is_on_floor():
		velocity.y = jump_velocity
		can_dash = true

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_dash = false

	# Dash
	if inputs["dash"] and can_dash:
		dash()

	move_and_slide()

func dash():
	can_dash = false
	velocity.x *= dash_speed / speed  # scale based on direction
	velocity.y = 0
	move_and_slide()
	await get_tree().create_timer(dash_time).timeout
