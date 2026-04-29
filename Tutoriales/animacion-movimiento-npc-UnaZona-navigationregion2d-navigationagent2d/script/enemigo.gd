extends CharacterBody2D


@onready var agent: NavigationAgent2D = $NavigationAgent2D
@export var speed: float = 50.0

var direccion := Vector2.ZERO #conocer la direccion de movimiento
var posicion_inicial = global_position #Para mantener el movimiento sobre un punto central

var esperando: bool = false #saber si esta en espera o no
var contador_espera: float = 0.0 #contador para la espera entre movimiento
var tiempo_espera: float = 0.0 #Para definir un tiempo de espera antes de cada movimiento

func _ready():
	posicion_inicial = global_position
	agent.path_desired_distance = 4.0 #para tener un rango de margen durante el camino al llegar a los destinos
	agent.target_desired_distance = 4.0 # Margen al llegar al destino, no un punto exacto, seria aproximado
	iniciar_espera()

func _process(delta: float) -> void:
	actualizar_animacion()

func _physics_process(delta):
	direccion = Vector2.ZERO #establecemos la direccion(animacion) como estatica (idl
	if esperando:
		contador_espera += delta
		if contador_espera >= tiempo_espera: #No caminamos hasta superar el tiempo de espera
			esperando = false
			moverse_a()
	else:
		if not agent.is_navigation_finished():  #Mientras no llegue al punto final entoces camina
			var next_point = agent.get_next_path_position()
			direccion = (next_point - global_position).normalized()
			velocity = direccion * speed
			move_and_slide()
			
			# Cambia la dirección aleatoriamente al chocar
			var collision = get_last_slide_collision()
			if collision: #Si choco con algo entonces establecemos nuevo mivimiento
				moverse_a()
		else:
			iniciar_espera()

func moverse_a(): #para establecer un movimiento aleatorio
	var random_offset = Vector2(randf_range(-200, 200), randf_range(-200, 200))
	#var nueva_posicion = global_position + random_offset #si quisieramos que el movimeinto no tenga limtes de direccion
	var nueva_posicion = posicion_inicial + random_offset
	agent.target_position = nueva_posicion

func iniciar_espera():
	esperando = true
	contador_espera = 0.0
	tiempo_espera = randf_range(0.0, 5.0)  # espera entre 0 y 5 segundos
	velocity = Vector2.ZERO  # detener el movimiento

func actualizar_animacion():
	var DireccionAnimacion = "Idle"
	$AnimatedSprite2D.set_flip_h(false) #Para girar el sprite de forma horizontal
	
	if (direccion.x <= -0.5):
		DireccionAnimacion = "IzqDer"
		$AnimatedSprite2D.set_flip_h(true)
	elif (direccion.x >= 0.5):
		DireccionAnimacion = "IzqDer"
	elif (direccion.y >= 0.5):
		DireccionAnimacion = "Abajo"
	elif (direccion.y <= -0.5):
		DireccionAnimacion = "Arriba"
	get_node("AnimatedSprite2D").play(DireccionAnimacion)
