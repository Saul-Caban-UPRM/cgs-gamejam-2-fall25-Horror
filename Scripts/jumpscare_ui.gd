extends CanvasLayer

@onready var img = $JumpscareImage
@onready var sound = $JumpscareSound  # Opcional

var showing := false

func _ready():
	img.visible = false
	img.modulate.a = 0

func show_jumpscare():
	if showing:
		return
	showing = true
	img.visible = true
	if sound:
		sound.play()

	# --- Tween para fade-in y fade-out ---
	var tween = get_tree().create_tween()
	tween.tween_property(img, "modulate:a", 1.0, 0.2)  # fade-in 0.2s
	tween.tween_interval(1.5)  # mantener visible
	tween.tween_property(img, "modulate:a", 0.0, 0.5)  # fade-out 0.5s
	tween.finished.connect(_on_jumpscare_finished)

func _on_jumpscare_finished():
	img.visible = false
	showing = false
