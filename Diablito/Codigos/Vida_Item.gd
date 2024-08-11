extends Area2D

# Señal emitida cuando el jugador recoge el item  No hace nada aun
signal item_collected

# Velocidad a la que el item sigue al jugador 
@export var speed: float = 100.0

# Cantidad de salud que restaura el item
@export var healing_amount: int = 1

# Indica si el item está siguiendo al jugador
var is_follow_player: bool = false
var player: CharacterBody2D

# Referencia al nodo Sprite2D del item
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Array de texturas para el item de curación
@export var healing_sprites: Array[Texture2D] = [
	preload("res://Recursos/Atun.png"),
	preload("res://Recursos/Pizza.png"),
	preload("res://Recursos/Hamburguesa.png")
]

# Función llamada cuando el nodo entra en el árbol de escena
func _ready() -> void:
	randomize()
	set_random_sprite()
	player = get_tree().get_nodes_in_group("player")[0]

# Función llamada en cada frame
func _process(delta: float) -> void:
	if is_follow_player:
		follow_player(delta)

# Establece una textura aleatoria para el sprite del item
func set_random_sprite() -> void:
	var random_index: int = randi() % healing_sprites.size()
	sprite.texture = healing_sprites[random_index]

# Hace que el item siga al jugador
func follow_player(delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(player.global_position)
	position += direction * speed * delta

# Llamada cuando un cuerpo entra en el área del item
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_following()

# Inicia el seguimiento del jugador
func start_following() -> void:
	is_follow_player = true
	animation_player.pause()

# Llamada cuando un cuerpo entra en el área de colisión del item
func _on_colision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		heal_player(body)
		emit_signal("item_collected")
		queue_free()

# Cura al jugador
func heal_player(body: Node2D) -> void:
	Globals.health_player = min(Globals.health_player + healing_amount, Globals.health_max_player)
	body.gui.update_health()
