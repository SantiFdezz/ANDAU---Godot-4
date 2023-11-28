extends Control


@export var bus_name: String = "Sfx"

@export var bus_index: int
var user_prefs: UserPreferences
func _ready() -> void:
	user_prefs = SettingsSignalBus.load_or_create()
	$HBoxContainer/VolumeSlider.value = SettingsSignalBus.settings["sfx_volume"]
	bus_index = AudioServer.get_bus_index(bus_name)
	_on_volume_slider_value_changed($HBoxContainer/VolumeSlider.value)


func _on_volume_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	SettingsSignalBus.emit_on_sfx_changed(value)
