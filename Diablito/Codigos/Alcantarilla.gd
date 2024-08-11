extends Node2D

func _ready():
	Globals.dead_enemies = 0

func _on_diablito_player_deleted():
	$CanvasLayer.visible = true
	get_tree().paused = true
		
