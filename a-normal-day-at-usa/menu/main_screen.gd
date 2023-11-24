extends CanvasLayer

@onready var options_menu = $Main_menu/Options_menu as OptionsMenu
@onready var start_menu = $Main_menu/MarginContainer as MarginContainer

func _ready():
	$MainMusic.play()
	options_menu.exit_options_menu.connect(Callable(on_exit_options_pressed))

func _on_play_pressed():
	$MainMusic.stop()
	get_tree().change_scene_to_file("res://zones/world.tscn")

func on_exit_options_pressed():
	start_menu.visible = true
	options_menu.visible = false
	
func _on_options_pressed():
	start_menu.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func _on_quit_pressed():
	get_tree().quit()
