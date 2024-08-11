extends CharacterBody3D

# Character variables
const JUMP_VELOCITY := 20.0
const GRAVITY := 30.0
const SENSIBILIDAD := 0.005
const SPRINT_SPEED := 15.0
const WALK_SPEED := 10.0
var speed := 0.0

# Fov variables
const BASE_FOV := 75.0
const FOV_CHANGE := 1.5
const MAX_FOV := 100

# puertas 
var abierto0 = -1

# Camera
const min_zoom := 6
const max_zoom := 10
const zoom_velocity := 1

@onready var checkpoint := global_position
@onready var cabeza := $Cabeza
@onready var camara := $Cabeza/Camara
@onready var pos_camara : Vector3 = camara.get_position()

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	

func _ready():
	# Mouse hidden
	scale = Vector3(0.3, 0.3, 0.3)
	position = Globals.spawn_inicial
	if len(get_tree().get_nodes_in_group("Player")) > 1:
		$Pivote/Personajes/Borracho1.hide()
		$Pivote/Personajes/Borracho2.show()
	camara.current = is_multiplayer_authority()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	
	if is_multiplayer_authority():
	
		# Movement
		if Input.is_action_pressed("SPRINT"):
			speed = SPRINT_SPEED
		else:
			speed = WALK_SPEED
		
		if not is_on_floor():
			velocity.y -= GRAVITY * delta
		if Input.is_action_just_pressed("ESPACE") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$Jump.playing = true

		var input_dir = Input.get_vector("A", "D", "W", "S")
		var direction = (cabeza.transform * Vector3(input_dir.x, 0, input_dir.y))
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		move_and_slide()
		
		# FOV
		var target_fov = BASE_FOV + FOV_CHANGE * velocity.length()
		camara.fov = lerp(camara.fov, target_fov, delta * 8.0)
		camara.fov = clamp(camara.fov, BASE_FOV, MAX_FOV)
		# Animation
		if velocity.x != 0 or velocity.z != 0:
			$Pivote.rotation.y = 3.2 + cabeza.rotation.y
			if not is_on_floor():
				$Polvo.emitting = false
			else:
				$Polvo.emitting = true
			if Input.is_action_pressed("SPRINT"):
				$Animaciones.play("Correr")
			else:
				caminar()
		else:
			if velocity.y != 0:
				caminar()
			else:
				$Polvo.emitting = false
				$Animaciones.play("Parado")
				
		# Camera zoom
		if Input.is_action_just_released("ZOOMUP"):
			camara.position.z = clamp(camara.position.z, min_zoom, max_zoom) + zoom_velocity
			
		if Input.is_action_just_released("ZOOMDOWN"):
			camara.position.z = clamp(camara.position.z, min_zoom, max_zoom) - zoom_velocity

func caminar() -> void:
	if $Pivote/Personajes.rotation.x > 0: 
		$Animaciones.play_backwards("Correr")
	else:
		$Animaciones.play("Caminar")

func _unhandled_input(event) -> void:
	
	# Mouse motion detection
	if event is InputEventMouseMotion:
		cabeza.rotate_y(-event.relative.x * SENSIBILIDAD)
		camara.rotate_x(-event.relative.y * SENSIBILIDAD)
		camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-40), deg_to_rad(60))
