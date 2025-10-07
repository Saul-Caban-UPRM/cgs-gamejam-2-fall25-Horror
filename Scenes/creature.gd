extends CharacterBody2D

@export var player_path: NodePath
@export var delay_frames := 20
@export var follow_speed := 0.1

var player
var jumpscare_ui
var jumpscare_triggered := false

func _ready():
	player = get_node(player_path)
	if not player:
		print("❌ No se encontró el jugador")

	# Busca el UI del jumpscare en el árbol
	jumpscare_ui = get_node("/root/Main/JumpscareUI")  # Ajusta esta ruta si tu escena principal se llama distinto
	if jumpscare_ui:
		print("✅ Nodo JumpscareUI encontrado correctamente")
	else:
		print("❌ No se encontró el nodo JumpscareUI")

	# Asegura que el Area2D esté configurado
	var area = $Area2D
	if area:
		area.monitoring = true
		area.monitorable = true
	else:
		print("⚠️ No se encontró el Area2D en Creature")

func _physics_process(delta):
	if not player:
		return

	# Movimiento tipo “eco” con delay
	var history_size = player.movement_history.size()
	if history_size <= delay_frames:
		return

	var target_index = history_size - delay_frames
	var target_pos = player.movement_history[target_index]
	global_position = global_position.lerp(target_pos, follow_speed)

# --- Señal del Area2D ---
func _on_area_2d_body_entered(body):
	if body.name == "Player" and not jumpscare_triggered:
		print("💀 El enemigo tocó al jugador — activando jumpscare")
		jumpscare_triggered = true
		if jumpscare_ui:
			jumpscare_ui.show_jumpscare()
		else:
			print("❌ jumpscare_ui no encontrado")
