extends Arma

const BULLET = preload("res://Escenas/Bala.tscn")

var can_shoot: bool = true

@onready var shoot_marker: Node2D = $Sprite2D/MarcaDeDisparo
@onready var gun_sprite: Sprite2D = $Sprite2D
@onready var occluder_abajo: LightOccluder2D = $OccluderAbajo
@onready var occluder_arriba: LightOccluder2D = $OccluderArriba
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	super._process(delta)
	update_sprite_orientation()
	if Input.is_action_just_pressed("Click_Izquierdo"):
		attack()

func update_sprite_orientation() -> void:
	if global_rotation > -1.5 and global_rotation < 1.5:
		gun_sprite.flip_v = false
		occluder_abajo.visible = true
		occluder_arriba.visible = false
	else:
		gun_sprite.flip_v = true
		occluder_abajo.visible = false
		occluder_arriba.visible = true

func attack() -> void:
	if can_shoot:
		shoot()
		audio.play()
		can_shoot = false
		timer.start()

func shoot() -> void:
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = shoot_marker.global_position
	new_bullet.global_rotation = shoot_marker.global_rotation
	shoot_marker.add_child(new_bullet)

func _on_timer_timeout() -> void:
	can_shoot = true
