extends Control

class_name OptionsMenu


@onready var exit_button = $MarginContainer/VBoxContainer/ExitButton as Button



signal exit_options_menu

func _on_exit_button_pressed():
	exit_options_menu.emit()
	set_process(false)
