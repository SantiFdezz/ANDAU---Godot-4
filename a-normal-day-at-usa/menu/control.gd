extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")


func _on_button_pressed():
	get_tree().quit()
