extends Control

@onready var option_menu = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY:Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720": Vector2i(1280, 720),
	"1920 x 1080": Vector2i(1920, 1080),
}

func _ready():
	add_window_mode_items()


func add_window_mode_items() -> void:
	for resolution_size in RESOLUTION_DICTIONARY:
		option_menu.add_item(resolution_size)
func _on_option_button_item_selected(index: int):
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
