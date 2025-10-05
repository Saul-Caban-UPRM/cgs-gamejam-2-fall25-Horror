extends CharacterBody2D

@export var player_path: NodePath
@export var delay_frames := 20  # how many frames behind it follows
var player

func _ready():
	player = get_node(player_path)

func _physics_process(delta):
	if not player:
		return

	var history_size = player.movement_history.size()
	if history_size > delay_frames:
		var index = history_size - delay_frames
		var target_pos = player.movement_history[index]
		global_position = global_position.lerp(target_pos, 0.3)
