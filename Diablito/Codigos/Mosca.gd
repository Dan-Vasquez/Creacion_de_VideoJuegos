# EnemigoRanged.gd
extends Enemigo

class_name EnemigoRanged

@export var attack_range: float = 150.0
@export var fire_rate: float = 1.0  # Disparos por segundo
@export var bullet_speed: float = 300.0

var can_fire: bool = true

@onready var shoot_timer: Timer = $ShootTimer
@onready var muzzle: Node2D = $Muzzle

const BULLET = preload("res://Escenas/Bala.tscn")

func _ready() -> void:
	super._ready()
	shoot_timer.wait_time = 1.0 / fire_rate
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))

func update_direction() -> void:
	super.update_direction()
	if is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < attack_range:
			direction = Vector2.ZERO
			look_at(player.global_position)
			if can_fire:
				attack()

func attack() -> void:
	if can_fire:
		shoot()
		can_fire = false
		shoot_timer.start()

func shoot() -> void:
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = muzzle.global_position
	new_bullet.global_rotation = global_rotation
	new_bullet.speed = bullet_speed
	new_bullet.damage = damage  # Usar el daño del enemigo para la bala
	get_tree().current_scene.add_child(new_bullet)
	
func _on_shoot_timer_timeout() -> void:
	can_fire = true
