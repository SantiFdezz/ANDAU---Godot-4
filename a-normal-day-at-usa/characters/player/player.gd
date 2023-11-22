extends CharacterBody2D

class_name Player

signal player_health_changed(new_health)
signal died
@export  var speed = 300
@export var bullet_scene: PackedScene
 
@onready var weapons: Node2D = $Weapons as Node2D
@onready var health_stat: Node2D = $Health 
@onready var team = $Team
@onready var blood : PackedScene = preload("res://characters/blood_particles.tscn")
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	$Weapons/Flash.hide()
	#weapons.initialize(team.team)
		
func _process(_delta):
	# inicializamos la rotación del personaje con la posicion en la dirección que apunta el ratón y calcula el ángulo entre el vector resultante y el eje X positivo 
	global_rotation = global_position.direction_to(get_global_mouse_position()).angle() 
	

func _physics_process(_delta):
	# Inicializamos la dirección del personaje, el metodo get_vector() toma varios parámetros correspondientes a las teclas mapeadas y genera un vector de dirección.
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	# cambiamos la animación según la posición  y velocidad requerida dependiendo de teclas
	weapons.hide()
	if Input.is_action_pressed("run"):
		$Character.play("run")
		velocity = direction * speed * 2
	else:
		velocity = direction * speed
		if Input.is_action_pressed("aim"):
			$Character.play("aim")
			weapons.show()
		elif Input.is_action_pressed("block"):
			$Character.play("block")
		else:
			$Character.play("walk")

	if velocity.length() > 0:
		move_and_slide()
	else:
		$Character.stop()


	# Aplicamos restricciones a la nueva posición para evitar que el objeto se salga de los límites de la pantalla.
	# uso global_position.x en vez de position porque en un Character body no toma los valores correctos para moverse en la totalidad de la pantalla.
	#global_position.x = clamp(global_position.x, 0, screen_size.x)
	#global_position.y = clamp(global_position.y, 0, screen_size.y)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot") && Input.is_action_pressed("aim"):
		if  not Input.is_action_pressed("run"):
			weapons.on_Player_shoot()
			
	elif Input.is_action_just_released("reload") && Input.is_action_pressed("aim"):
		weapons.start_reload()
func get_team() -> int:
	return team.team
	
func reload():
	weapons.start_reload()

func hitted():
	if Input.is_action_pressed("block") :
		health_stat.status -=10
	else:
		health_stat.status -= 20
		print('hit')
	get_node("/root/Main/GUI").set_new_health_value(health_stat.status)
	#player_health_changed.emit()
	#player_health_changed.emit_signal("player_health_changed",health_stat.status)
	#ANIMACION SANGRE
	var blood_inst = blood.instantiate()
	blood_inst.global_position = global_position
	get_tree().get_root().add_child(blood_inst)
	#MUERTE PLAYER
	if health_stat.status <= 0:
		died.emit()
		$Character.play("dead")
		queue_free()
	
	
	
	