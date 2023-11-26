extends Control

class_name Pause

signal exit_game
var world : Node2D
var _is_paused :bool = false: 
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible= _is_paused
		$PauseCenterContainer.visible = _is_paused
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready():
	hide()
	#var world = get_parent()
func _on_game_paused(is_paused):
	if is_paused:
		show()
	else:
		hide()
func _process(_delta):
	if Input.is_action_pressed("pause"):
		_is_paused = !_is_paused
		if !_is_paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			exit_game.emit()
	if get_tree().paused:
		show()
	else:
		hide()
#func set_paused(value: bool)-> void:
#	_is_paused = value
#	get_tree().paused = _is_paused
#	visible = _is_paused

#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("pause"):
#		_is_paused = !_is_paused
#		if !_is_paused:
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://menu/main_screen.tscn")
	exit_game.emit()
	world.set_process(false)

func _on_resume_button_pressed():
	get_tree().paused = false
	#_is_paused = false
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
