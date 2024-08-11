extends CharacterBody2D

# Señal emitida cuando el jugador es eliminado
signal player_deleted

# Constantes
const SPEED: float = 100.0
const PARTICLES = preload("res://Escenas/Sangre.tscn")

# Variables de movimiento y efectos
var direction: Vector2
var timer: float = 0.0
var intensity: float = 2.0
var shake_enable: bool = false

# Nodos del jugador
@onready var current_weapon: Node2D = $Arma_Blanca
@onready var character_sprite: Sprite2D = $Sprite2D
@onready var occluder_derecho: LightOccluder2D = $OccluderDerecho
@onready var occluder_izquierdo: LightOccluder2D = $OccluderIzquierdo
@onready var camera: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player2: AnimationPlayer = $AnimationPlayer2
@onready var herida_sound: AudioStreamPlayer2D = $Herida
@onready var gui: Node = $GUI

# Variables exportadas para ajustar desde el editor
@export var camera_shake_duration: float = 0.2
@export var camera_shake_intensity: float = 2.0

func _ready() -> void:
	change_weapon()

func _process(delta: float) -> void:
	handle_movement()
	animate_character()
	handle_camera_shake(delta)

# Maneja el movimiento del jugador
func handle_movement() -> void:
	direction = Input.get_vector("A", "D", "W", "S")
	velocity = direction * SPEED
	move_and_slide()

# Controla las animaciones del personaje
func animate_character() -> void:
	if velocity.length() > 0:
		animation_player.play("Movimiento")
	else:
		animation_player.play("Parado")
	
	update_character_orientation()

# Actualiza la orientación del personaje basado en la dirección
func update_character_orientation() -> void:
	if direction.x < 0:
		character_sprite.flip_h = true
		occluder_derecho.visible = false
		occluder_izquierdo.visible = true
	else:
		character_sprite.flip_h = false
		occluder_derecho.visible = true
		occluder_izquierdo.visible = false

# Maneja el efecto de sacudida de la cámara
func handle_camera_shake(delta: float) -> void:
	if shake_enable and timer < camera_shake_duration:
		var offset = Vector2(randf() * camera_shake_intensity, randf() * camera_shake_intensity)
		camera.offset = offset
		timer += delta
	else:
		camera.offset = Vector2.ZERO
		timer = 0
		shake_enable = false

# Maneja el daño recibido por el jugador
func _on_heridas_body_entered(body: Node) -> void:
	if body.has_method("harm"):
		apply_damage_effects()
		apply_damage(body.harm())

# Aplica los efectos visuales y sonoros del daño
func apply_damage_effects() -> void:
	herida_sound.play()
	animation_player2.play("Flash_Herida")
	shake_enable = true
	spawn_blood_particles()

# Genera partículas de sangre
func spawn_blood_particles() -> void:
	var new_particles = PARTICLES.instantiate()
	new_particles.emitting = true
	get_parent().add_child(new_particles)
	new_particles.global_position = global_position

# Aplica el daño al jugador
func apply_damage(damage: int) -> void:
	Globals.health_player -= damage
	gui.update_health()
	if Globals.health_player <= 0:
		player_deleted.emit()
		Globals.reset()

# Actualiza el contador de asesinatos
func murder_counter() -> void:
	gui.update_murders()

# Cambia el arma del jugador
func change_weapon() -> void:
	if Globals.visible_weapon:
		current_weapon.set_process_mode(PROCESS_MODE_DISABLED)
		current_weapon.visible = false
		
		match Globals.weapon_in_use:
			1:
				set_current_weapon($Arma_Blanca)
			2:
				set_current_weapon($Arma_Blanca2)
				print($Arma_Blanca2.damage)
			3:
				set_current_weapon($Arma_Fuego)

# Establece el arma actual
func set_current_weapon(weapon: Node2D) -> void:
	weapon.set_process_mode(PROCESS_MODE_INHERIT)
	weapon.visible = true
	current_weapon = weapon
