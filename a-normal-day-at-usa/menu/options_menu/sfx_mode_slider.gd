extends Control


@export var bus_name: String = "Sfx"

@export var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)


func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
