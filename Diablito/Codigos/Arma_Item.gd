extends Area2D

# Señal emitida cuando se recoge el arma No hace nada aun
signal weapon_collected(weapon_type: int)

# Velocidad a la que el item sigue al jugador
@export var speed: float = 100.0

# Array de texturas para las armas
@export var weapon_sprites: Array[Texture2D] = [
	preload("res://Recursos/Botella_Rota.png"),
	preload("res://Recursos/Cuchillo_Roto.png"),
	preload("res://Recursos/Pistola_Oxidada.png")
]

# Tipo de arma que representa este item
@export var weapon_type: int = 3

var is_follow_player: bool = false
var player: CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	set_weapon_sprite()
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta: float) -> void:
	if is_follow_player:
		follow_player(delta)

# Establece la textura del arma basada en weapon_type
func set_weapon_sprite() -> void:
	if weapon_type >= 1 and weapon_type <= weapon_sprites.size():
		sprite.texture = weapon_sprites[weapon_type - 1]

# Hace que el item siga al jugador
func follow_player(delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(player.global_position)
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_following()

# Inicia el seguimiento del jugador
func start_following() -> void:
	is_follow_player = true
	animation_player.pause()

func _on_colision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collect_weapon(body)

# Maneja la recolección del arma
func collect_weapon(body: Node2D) -> void:
	Globals.weapon_in_use = weapon_type
	Globals.visible_weapon = true
	body.change_weapon()
	emit_signal("weapon_collected", weapon_type)
	queue_free()
