extends Node2D


var capturable_bases: Array = []


func _ready() -> void:
	capturable_bases = get_children()

func get_capturable_bases():
	return capturable_bases
	
func handle_capturable_bases():
	var player_bases = 0
	var enemy_bases = 0
	var total_bases = capturable_bases.size()
	for base in capturable_bases:
			match base.team.team:
				Team.TeamName.PLAYER:
					player_bases +=1
					print("estas son las "+str(player_bases))
				Team.TeamName.ENEMY:
					enemy_bases +=1
				Team.TeamName.NEUTRAL:
					return
			if player_bases == total_bases:
				get_parent().handle_player_win(player_bases)
			elif enemy_bases == total_bases:
				get_parent().handle_player_lost(player_bases)

				
					
