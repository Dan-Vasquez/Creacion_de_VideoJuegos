extends MeshInstance3D

func _on_area_3d_body_entered(body):
	if body in get_tree().get_nodes_in_group("player"):
		#body.queue_free()
		#get_tree().reload_current_scene()
		body.global_position = body.checkpoint 
