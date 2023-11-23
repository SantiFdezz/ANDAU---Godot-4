extends CanvasLayer

@onready var title = $PanelContainer/MarginContainer/Rows/Title

func set_title(win: bool):
	if win:
		title.text = "YOU WIN!!"
		title.modulate = Color.GREEN
	else:
		title.text = "YOU LOSE :("
		title.modulate = Color.RED
func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://zones/world.tscn")


func _on_main_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
