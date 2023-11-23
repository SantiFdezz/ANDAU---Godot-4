extends CanvasLayer

class_name Pause


var _is_paused:bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		$Pause.visible = _is_paused
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused
		if _is_paused==false and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _on_exit_button_pressed():
	_is_paused = false
	get_tree().quit()

func _on_resume_button_pressed():
	_is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
