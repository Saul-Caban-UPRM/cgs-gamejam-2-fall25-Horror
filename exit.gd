extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func _on_Hitbox_body_entered(body):
	if body.name == "Player":  # O usa groups
		get_tree().change_scene_to_file("res://win.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # O usa groups
		get_tree().change_scene_to_file("res://win.tscn")
