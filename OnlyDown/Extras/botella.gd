extends StaticBody3D

var repeticiones = 0

func _on_area_3d_body_entered(body):
	if body in get_tree().get_nodes_in_group("Player"):
		Globals.botellas_recolectadas += 1
		if repeticiones == 0:
			$Coin.playing = true
			repeticiones += 1
		
func _on_coin_finished():
	queue_free()
