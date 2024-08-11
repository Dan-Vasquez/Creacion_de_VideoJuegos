extends CanvasLayer

func cambiar_escena(direccion: String) -> void:
	$ColorRect.set_visible(true)
	$AnimationPlayer.play("Cambio")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(direccion)
	$AnimationPlayer.play_backwards("Cambio")
	await $AnimationPlayer.animation_finished
	$ColorRect.set_visible(false)

func salir() -> void:
	$ColorRect.set_visible(true)
	$AnimationPlayer.play("Cambio")
	await $AnimationPlayer.animation_finished
	get_tree().quit()
