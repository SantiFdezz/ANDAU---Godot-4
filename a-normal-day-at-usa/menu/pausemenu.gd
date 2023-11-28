extends Control

class_name Pause


var _is_paused:bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible = _is_paused
		$".".visible = _is_paused
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused


func _on_resume_button_pressed():
	_is_paused = false


func _on_main_button_pressed():
	_is_paused = false
	get_tree().change_scene_to_file("res://menu/main_screen.tscn")
