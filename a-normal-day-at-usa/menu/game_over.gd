extends CanvasLayer

@onready var title = $PanelContainer/MarginContainer/Rows/Title

func _ready():
	$".".visible = false

func set_title(win: bool, player_bases: int):
	if win:
		title.text = "GANASTE!!  "+"+"+str(player_bases)+" bases! "
		title.modulate = Color.GREEN
	else:
		title.text = "PERDISTE :("
		title.modulate = Color.RED
	$".".visible = true
		
func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://zones/world.tscn")


func _on_main_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
