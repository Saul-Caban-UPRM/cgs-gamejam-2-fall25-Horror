extends CharacterBody2D

@export var player_path: NodePath
@export var delay_frames := 20
@export var follow_speed := 0.1
@export var collision_distance := 20

var player
var jumpscare_ui
var jumpscare_triggered := false

func _ready():
	player = get_node(player_path)
	if not player:
		print("❌ No se encontró el jugador")
	
	jumpscare_ui = get_node("/root/Main/JumpscareUI")  # Ajusta la ruta absoluta
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
		return

	var target_index = history_size - delay_frames
	var target_pos = player.movement_history[target_index]
	global_position = global_position.lerp(target_pos, follow_speed)

	# --- Detectar colisión con jugador ---
	if not jumpscare_triggered and global_position.distance_to(player.global_position) < collision_distance:
		trigger_jumpscare()
		jumpscare_triggered = true

func trigger_jumpscare():
	print("💀 Jumpscare activado")
	if jumpscare_ui:
		jumpscare_ui.show_jumpscare()


func _on_Hitbox_body_entered(body):
	if body.name == "Player":  # O usa groups
		trigger_jumpscare()
