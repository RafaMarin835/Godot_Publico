extends CharacterBody2D

@export var velocidad := 50 
var direccion := Vector2.ZERO 
var destino: Vector2
var existe_destino = false

func _ready() -> void:
	generar_nuevo_destino() #generamos un destino inicial

func _physics_process(delta: float) -> void:
	movimiento() 

func _process(delta: float) -> void:
	actualizar_animacion()

func generar_nuevo_destino():
	# Genera una nueva posición aleatoria dentro de un rango
	var rango = 50 #lo cambiamos segun el rango de movimiento deseado
	destino = global_position + Vector2(randf_range(-rango, rango), randf_range(-rango, rango))
	existe_destino = true

func movimiento():
	if existe_destino: #verificar que se tiene un destino
		direccion = (destino - global_position).normalized() #Direccion a tomar entre la posicion actual y el destino
		velocity = direccion * velocidad
		move_and_slide()
		
		if get_slide_collision_count() > 0:
			generar_nuevo_destino()
		
		# Verifica si llegó al destino
		if global_position.distance_to(destino) < 5:
			velocity = Vector2.ZERO
			existe_destino = false
			await get_tree().create_timer(randf_range(0.5, 5)).timeout  # esperamos 1.5 segundos
			generar_nuevo_destino()

func actualizar_animacion():
	var DireccionAnimacion = "Idle"
	
	if (direccion.x <= -0.5):
		DireccionAnimacion = "Izquierda"
	elif (direccion.x >= 0.5):
		DireccionAnimacion = "Derecha"
	elif (direccion.y >= 0.5):
		DireccionAnimacion = "Abajo"
	elif (direccion.y <= -0.5):
		DireccionAnimacion = "Arriba"
	get_node("AnimatedSprite2D").play(DireccionAnimacion)
