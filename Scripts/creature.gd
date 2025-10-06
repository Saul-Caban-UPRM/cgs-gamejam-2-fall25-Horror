extends CharacterBody2D

@export var speed := 200
@export var catchup_multiplier := 1.8
@export var chase_factor := 2.5   # pixels -> target velocity (tune)
@export var gravity := 1000
@export var jump_force := -600
@export var jump_tolerance := 20
@export var jump_ahead_distance := 40  # how far to look ahead in pixels
var direction := 1  # current facing (-1 = left, 1 = right)
@onready var sprite: Sprite2D = $Sprite2D
var player: CharacterBody2D

# Set true to temporarily ignore physics collisions for horizontal movement (debug)
var bypass_physics_for_debug := false

func _ready():
	player = get_parent().get_node("Player")

func _physics_process(delta):
	if not player:
		return

	# Distance to player
	var dx = player.global_position.x - global_position.x
	var dy = player.global_position.y - global_position.y

	# Update facing direction (-1 left, 1 right)
	if dx != 0:
		direction = sign(dx)

	# Horizontal movement
	velocity.x = direction * speed

	# Jump if player is above
	if dy < -jump_tolerance and is_on_floor():
		velocity.y = jump_force

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Move enemy
	move_and_slide()
