extends Area2D

class_name Bullet

# Velocidad de la bala en píxeles por segundo
@export var speed: float = 300.0

# Rango máximo de la bala en píxeles
@export var max_range: float = 400.0

# Daño que causa la bala al impactar
@export var damage: int = 0

# Escena de partículas para la explosión de la bala
const PARTICLES: PackedScene = preload("res://Escenas/Explosion_Bala.tscn")

# Dirección de movimiento de la bala
var direction: Vector2 = Vector2.RIGHT

# Distancia recorrida por la bala
var travel_distance: float = 0.0

func _physics_process(delta: float) -> void:
	move_bullet(delta)
	check_range()

# Mueve la bala en la dirección establecida
func move_bullet(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	travel_distance += speed * delta

# Comprueba si la bala ha superado su rango máximo
func check_range() -> void:
	if travel_distance > max_range:
		queue_free()

func _on_body_entered(body: Node) -> void:
	spawn_impact_particles()
	apply_damage(body)
	queue_free()

# Genera las partículas de impacto
func spawn_impact_particles() -> void:
	var new_particles: CPUParticles2D = PARTICLES.instantiate()
	get_tree().current_scene.add_child(new_particles)
	new_particles.global_position = global_position
	new_particles.emitting = true

# Aplica el daño al cuerpo impactado si es posible
func apply_damage(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
