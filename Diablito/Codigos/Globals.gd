extends Node

var health_max_player = 5
var dead_enemies = 0
var weapon_in_use = 0
var visible_weapon = false

@onready var health_player = health_max_player

func _ready():
	pass

func _process(_delta):
	pass
	
func reset():
	health_player = health_max_player
	dead_enemies = 0
	weapon_in_use = 0
	visible_weapon = false
