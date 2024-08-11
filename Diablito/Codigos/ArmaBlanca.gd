extends Arma

class_name ArmaBlanca

@onready var animaciones: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Sprite2D/Area2D

func _ready() -> void:
	area.monitoring = false

func attack() -> void:
	if not animaciones.is_playing():
		animaciones.play("Ataque")

func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("Click_Izquierdo"):
		attack()
