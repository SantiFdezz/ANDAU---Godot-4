extends Control


@onready var option_menu = $HBoxContainer/OptionButton as OptionButton
var user_prefs: UserPreferences

const WINDOW_MODE_ARRAY: Array[String]= [
	"Pantalla completa",
	"Modo ventana",
	"Pantalla completa sin bordes",
	"Ventana sin bordes"
]

func _ready():
	user_prefs = SettingsSignalBus.load_or_create()
	add_window_mode_items()
	$HBoxContainer/OptionButton.selected = SettingsSignalBus.settings["window_mode_index"]
	_on_option_button_item_selected($HBoxContainer/OptionButton.selected)


func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		option_menu.add_item(window_mode)
func _on_option_button_item_selected(index: int):
	match index:
		0: #fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	SettingsSignalBus.emit_on_window_changed(index)
