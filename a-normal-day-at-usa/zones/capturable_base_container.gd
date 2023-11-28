extends Node2D


var capturable_bases: Array = []
var gametimer: Timer
var finish: bool = false
func _ready() -> void:
	capturable_bases = get_children()
func _process(_delta):
	if !finish:
		handle_capturable_bases()
func get_capturable_bases():
	return capturable_bases
	
func handle_capturable_bases():
	var player_bases = 0
	var enemy_bases = 0
	var total_bases = capturable_bases.size()
	var player_died = get_parent().get_player_died()
	if player_died == false:
		for base in capturable_bases:
			match base.team.team:
				Team.TeamName.PLAYER:
					player_bases +=1
				Team.TeamName.ENEMY:
					enemy_bases +=1
				Team.TeamName.NEUTRAL:
					continue
			
			if player_bases == total_bases:
				finish = true
				var username = SettingsSignalBus.settings["username"]
				get_parent().handle_player_win(username, player_bases)
	else:
		finish = true
		var username = SettingsSignalBus.settings["username"]
		get_parent().handle_player_lost(username, player_bases)

