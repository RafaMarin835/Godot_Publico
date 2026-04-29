extends CharacterBody2D

@onready var path_follow = get_parent()  # Asumiendo que es hijo de PathFollow2D
var speed = 50

var tiempo_pausa = 0.0
var pausa = false

var direccion: Vector2
var posicion_anterior: Vector2

func _ready():
	posicion_anterior = path_follow.global_position

func _physics_process(delta: float) -> void:
	direccion = Vector2.ZERO #para iniciar animacion estatica
	
	tiempo_pausa -= delta
	if pausa:
		if tiempo_pausa <= 0.0:
			pausa = false
			tiempo_pausa = randf_range(1.0, 8.0) #el rango de tiempo caminando
	else:
		if tiempo_pausa <= 0.0:
			pausa = true
			tiempo_pausa = randf_range(1.0, 5.0) #el rango de tiempo de la pausa
		path_follow.progress += speed * delta
	
	var pos = path_follow.global_position
	direccion = (pos - posicion_anterior).normalized()
	posicion_anterior = pos

func _process(delta: float) -> void:
	actualizar_animacion()

func actualizar_animacion():
	var DireccionAnimacion = "Idle"
	
	if direccion.x <= -0.5:
		DireccionAnimacion = "Izquierda"
	elif direccion.x >= 0.5:
		DireccionAnimacion = "Derecha"
	elif direccion.y >= 0.5:
		DireccionAnimacion = "Abajo"
	elif direccion.y <= -0.5:
		DireccionAnimacion = "Arriba"

	get_node("AnimatedSprite2D").play(DireccionAnimacion)
