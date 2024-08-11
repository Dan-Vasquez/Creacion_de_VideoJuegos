extends Node2D

class_name Arma

var damage: int = 1

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func attack() -> void:
	pass  # Será implementado en las clases hijas

func _on_area_2d_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
