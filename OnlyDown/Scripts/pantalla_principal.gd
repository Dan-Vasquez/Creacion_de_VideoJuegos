extends Control

func _process(delta):
	if Input.is_action_just_pressed("ESPACE"):
		TransicionEscenas.cambiar_escena("res://Escenas/Menus/niveles.tscn")

func _on_jugar_pressed():
	TransicionEscenas.cambiar_escena("res://Escenas/Menus/niveles.tscn")
