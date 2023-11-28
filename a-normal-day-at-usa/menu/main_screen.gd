extends CanvasLayer

@onready var options_menu = $Main_menu/Options_menu as OptionsMenu
@onready var start_menu = $Main_menu/MarginContainer as MarginContainer
var world: Node2D 
var user_prefs: UserPreferences
func _ready():
	get_tree().paused = false
	user_prefs = SettingsSignalBus.load_or_create()
	$MainMusic.play()
	options_menu.exit_options_menu.connect(Callable(on_exit_options_pressed))
	
	
func initialize(new_world: Node2D):
	self.world = new_world
	world.exit_game.connect(Callable(on_exit_game_pressed))
	
func _on_play_pressed():
	$MainMusic.stop()
	get_tree().change_scene_to_file("res://zones/world.tscn")

func on_exit_game_pressed():
	start_menu.visible = true
	world.hide()

func on_exit_options_pressed():
	start_menu.visible = true
	options_menu.visible = false
	
func _on_options_pressed():
	start_menu.visible = false
	options_menu.set_process(true)
	options_menu.visible = true


func _on_quit_pressed():
	get_tree().quit()
