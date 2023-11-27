extends Control


@export var bus_name: String = "Music"
var user_prefs: UserPreferences
@export var bus_index: int

func _ready() -> void:
	user_prefs = SettingsSignalBus.load_or_create()
	$HBoxContainer/VolumeSlider.value = SettingsSignalBus.settings["music_volume"]
	#bus_index = AudioServer.get_bus_index(bus_name)


func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	SettingsSignalBus.emit_on_music_changed(value)
