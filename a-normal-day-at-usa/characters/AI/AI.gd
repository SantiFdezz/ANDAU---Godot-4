extends Node2D

class_name AI

signal state_changed(new_state)

enum State{
	PATROL,
	ENGAGE
}
#@onready var patrol_timer = $PatrolTimer
var weapon: Weapon = null
var velocity: Vector2 = Vector2.ZERO
var target: CharacterBody2D = null
var current_state : int = -1 : set = set_state
var actor: Actor  = null
#PATROL STATE:
var origin: Vector2 = Vector2.ZERO
var patrol_location : Vector2 = Vector2.ZERO
var patrol_location_reached : bool = false
var team: int =-1
@onready var player: Player

func _ready() -> void:
	randomize()
	set_state(State.PATROL)

#Actualizamos lo que tiene que hacer en sus diferentes estados
func _physics_process(_delta: float) ->void:
	match current_state:
		State.PATROL:
			#Si la ia no llego al destino y no esta en 'ENGAGE' se mueve 
			if not patrol_location_reached:
				actor.move_and_slide() 
				actor.rotate_toward(patrol_location)
				#falta stopear el timer en algun momento
				if actor.has_reached_position(patrol_location):
					patrol_location_reached = true
					velocity = Vector2.ZERO
					$PatrolTimer.start()
		State.ENGAGE:
			if target != null and weapon != null:
				#rotacion de la ia para buscar donde esta el player
				actor.rotate_toward(target.global_position)
				actor.move_and_slide()
				var angle_to_target =  actor.global_position.direction_to(target.global_position).angle()
				if actor.name != "Boss":
					if abs(actor.global_rotation - angle_to_target)< 0.35:
						weapon.on_shoot()
				else:
					if abs(actor.global_rotation - angle_to_target)< 0.35:
						weapon.on_smg_shoot()
			else:
				print("Persiguiendo pero, no hay arma/player")
		_:
				print('Error: Encontraste un estado de la IA que no debería existir!!')

func initialize(new_actor: CharacterBody2D, new_weapon: Weapon, new_team: int):
	self.actor = new_actor
	self.weapon = new_weapon
	self.team = new_team

func set_state(new_state: int):
	if new_state == current_state:
		pass
	if new_state == State.PATROL:
		origin = global_position
		$PatrolTimer.autostart = true
		patrol_location_reached = true
	elif new_state == State.ENGAGE:
		$PatrolTimer.stop()

	current_state = new_state
	emit_signal("state_changed", current_state) 

func _on_patrol_timer_timeout():
	var patrol_range = 50
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location = patrol_location
	patrol_location_reached = false
	actor.velocity = actor.velocity_toward(patrol_location)


func _on_DetectionZoneBodyEntered(body: Node) ->void:
	if body.has_method("get_team") and body.get_team() != team :
		set_state(State.ENGAGE)
		target = body

	## prueba si los demas compañeros se activan la estar en un radio


func _on_DetectionZoneBodyExited(body: Node) -> void:
	if target and body == target:
		set_state(State.PATROL)
		if $PatrolTimer == null:
			target = null


func _on_weapons_out_of_ammo():
	weapon.start_reload_enemy()


