extends Area2D

class_name CapturableBase

signal base_captured(new_team)

@export var enemy_color: Color = Color(0.694, 0, 0)
@export var player_color: Color = Color(0, 0.467, 0.953)
@export var neutral_color: Color = Color(1, 1, 1)

var enemy_unit_count: int = 0
var player_unit_count: int = 0
var team_to_capture: int = Team.TeamName.NEUTRAL

@onready var team = $Team
@onready var capture_timer = $CaptureTimer
@onready var flag = $Flag

#si entro un cuerpo en el area2d suma al contrario 
func _on_CapturableBase_body_entered(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count += 1
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count += 1
		check_base_can_be_capturable()

#si salio un cuerpo en el area2d resta al contrario 
func _on_CapturableBase_body_exited(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count -= 1
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count -= 1
		
		check_base_can_be_capturable()
			
#comprobamos si la base puede serr capturada
func check_base_can_be_capturable():
	var majority_team = get_team_with_majority()
	if majority_team == Team.TeamName.NEUTRAL:
		return
	elif majority_team == team.team:
		print("Han ganado un puesto un equipo ")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	else:
		print("Estan ganando un puesto un equipo ")
		team_to_capture = majority_team
		capture_timer.start()

func get_team_with_majority():
	if enemy_unit_count == player_unit_count:
		return Team.TeamName.NEUTRAL
	elif enemy_unit_count > player_unit_count:
		return Team.TeamName.ENEMY
	else:
		return Team.TeamName.PLAYER

func set_team(new_team: int):
	team.team = new_team
	emit_signal("base_captured", new_team)
	match new_team:
		Team.TeamName.NEUTRAL:
			flag.modulate = neutral_color
			return
		Team.TeamName.ENEMY:
			flag.modulate = enemy_color
			return
		Team.TeamName.PLAYER:
			flag.modulate = player_color
			return
func _on_capture_timer_timeout():
	set_team(team_to_capture)
