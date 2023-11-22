extends Node2D

# inicializamos salud en 100 y añadimos setters y getters
@export var status : int = 100 : set = set_health, get = get_health

func set_health(new_health: int):
	status = clamp(new_health, 0, 100)
	
func get_health():
	return status
