extends CharacterBody2D

class_name Enemigo

@export var speed: float = 60.0
@export var detection_radius: float = 100.0
@export var max_health: int = 2
@export var damage: int = 1

var direction: Vector2 = Vector2.ZERO
var health: int

@onready var player: CharacterBody2D = get_node("/root/Alcantarilla/Diablito")
@onready var enemy_sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player2: AnimationPlayer = $AnimationPlayer2
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

const PARTICLES = preload("res://Escenas/Sangre.tscn")

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	update_direction()
	move()
	animate()

func update_direction() -> void:
	if is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < detection_radius:
			direction = global_position.direction_to(player.global_position)
		else:
			direction = Vector2.ZERO

func move() -> void:
	velocity = direction * speed
	move_and_slide()

func animate() -> void:
	if velocity.length() > 0:
		animation_player.play("Movimiento")
	else:
		animation_player.play("Parado")
	
	enemy_sprite.flip_h = direction.x >= 0

func take_damage(value: int) -> void:
	audio_player.play()
	animation_player2.play("Flash_Herida")
	player.shake_enable = true
	spawn_blood_particles()
	
	health -= value
	
	if health <= 0:
		die()

func spawn_blood_particles() -> void:
	var new_particles = PARTICLES.instantiate()
	new_particles.emitting = true
	get_tree().current_scene.add_child(new_particles)
	new_particles.global_position = global_position

func die() -> void:
	Globals.dead_enemies += 1
	player.murder_counter()
	queue_free()

func attack() -> void:
	# Será implementado en las clases hijas
	pass

func harm() -> int:
	return damage
