extends CharacterBody2D

@export var player_path: NodePath
@export var delay_frames := 20
@export var follow_speed := 0.1
@export var collision_distance := 20

var player
var jumpscare_ui
var jumpscare_triggered := false

@onready var anim_player = $CreatureAnimations  # Your AnimatedSprite2D or AnimationPlayer

func _ready():
	player = get_node(player_path)
	if not player:
		print("❌ No se encontró el jugador")
	
	jumpscare_ui = get_node("/root/Main/JumpscareUI")
	if jumpscare_ui:
		print("✅ Nodo JumpscareUI encontrado correctamente")
	else:
		print("❌ No se encontró el nodo JumpscareUI")

func _physics_process(delta):
	if not player:
		return

	# --- Seguir al jugador con delay ---
	var history_size = player.movement_history.size()
	if history_size <= delay_frames:
		update_animation("Idle")
		return

	var target_index = history_size - delay_frames
	var target_pos = player.movement_history[target_index]

	var previous_position = global_position
	global_position = global_position.lerp(target_pos, follow_speed)

	# --- Determinar movimiento para animaciones ---
	var velocity_vector = global_position - previous_position

	if velocity_vector.length() > 1:  # moving
		update_animation("Walking")
	else:
		update_animation("Idle")

	# --- 🔁 Flip sprite depending on movement direction ---
	if velocity_vector.x != 0:
		if anim_player.has_method("set_flip_h"):  # Works for AnimatedSprite2D or Sprite2D
			anim_player.flip_h = velocity_vector.x < 0
		elif anim_player is AnimationPlayer:
			# If using AnimationPlayer with a separate Sprite2D
			var sprite = anim_player.get_parent().get_node_or_null("Sprite2D")
			if sprite:
				sprite.flip_h = velocity_vector.x < 0

	# --- Detectar colisión con jugador ---
	if not jumpscare_triggered and global_position.distance_to(player.global_position) < collision_distance:
		trigger_jumpscare()
		jumpscare_triggered = true


func trigger_jumpscare():
	print("💀 Jumpscare activado")
	if jumpscare_ui:
		jumpscare_ui.show_jumpscare()
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		trigger_jumpscare()


func update_animation(animation):
	if animation == "Walking":
		anim_player.play("Walking")
	elif animation == "Idle":
		anim_player.play("Idle")
