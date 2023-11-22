extends Node2D


var capturable_bases: Array = []


func _ready() -> void:
	capturable_bases = get_children()

func get_capturable_bases():
	return capturable_bases
