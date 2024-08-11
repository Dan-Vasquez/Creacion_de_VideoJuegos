extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
			visible = !visible
			#get_tree().paused = visible
			if visible:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _on_salir_pressed():
	#get_parent().exit_game(name.to_int())
	TransicionEscenas.salir()

func _on_jugar_pressed():
	visible = !visible
	#get_tree().paused = visible
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resetear_pressed():
	#get_tree().paused = false
	visible = !visible
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for body in get_tree().get_nodes_in_group("Player"):
		body.global_position = body.checkpoint 

func _on_menu_pressed():
	#get_tree().paused = false
	TransicionEscenas.cambiar_escena("res://Escenas/Menus/niveles.tscn")
	
