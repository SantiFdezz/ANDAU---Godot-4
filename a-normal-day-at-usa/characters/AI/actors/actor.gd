extends CharacterBody2D

class_name Actor

signal died

@onready var health = $Health
@onready var weapon: Weapon = $Weapons
@onready var ai = $AI
@onready var team = $Team
@onready var blood : PackedScene = preload("res://characters/blood_particles.tscn")

var dead_position : Vector2

@export var speed : int = 100
func _ready():
	$Weapons/Flash.hide()
	ai.initialize(self, weapon, team.team)
	weapon.initialize(team.team)
	
	
	
func rotate_toward(location: Vector2):
	global_rotation = lerp_angle(global_rotation, global_position.direction_to(location).angle(), 0.1)

func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
	
func has_reached_position(location: Vector2) ->bool:
	return global_position.distance_to(location) < 5

func hitted():
	health.status -= randi_range(20, 50)
	print("Al enemigo le queda "+ str(health.status)+ " de daño")
	var blood_inst = blood.instantiate()
	blood_inst.global_position = global_position
	get_tree().get_root().add_child(blood_inst)
	if health.status <= 0:
		weapon.hide()
		weapon.set_process(false) 
		$Character.hide()
		$DeadCharacter.play("dead")
		await get_tree().create_timer(2.0).timeout
		#emit_signal("died")
		died.emit()
		queue_free()
		## cambia script 

func get_team() -> int:
	return team.team
		

