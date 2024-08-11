extends Control


func _process(delta):
	$VBoxContainer/Label.text = "Secciones superadas: " + str(Globals.check_points_pisados) + " / 5\n" + "Botellas Conseguidas: " + str(Globals.botellas_recolectadas) + " / 157"

func _on_nivel_1_pressed():
	TransicionEscenas.cambiar_escena("res://Escenas/Niveles/pruebas.tscn")


func _on_salir_pressed():
	TransicionEscenas.salir()
