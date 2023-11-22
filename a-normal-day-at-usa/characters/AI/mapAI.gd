extends Node2D

var capturable_bases: Array = []


@export var unit : PackedScene = null 
var respawn_points: Array = []
@onready var unit_container = $UnitContainer
@export var max_units_alive = 15 
var next_spawn_to_use: int = 0

func initialize(capturable_bases: Array, respawn_points: Array):
	if respawn_points.size() == 0 or capturable_bases.size() == 0 or unit == null:
		push_error("Olvidaste inicializar adecuadamente el MapAI")
		return
	self.capturable_bases = capturable_bases
	self.respawn_points = respawn_points
	for respawn in respawn_points:
		spawn_unit(respawn.global_position)

func spawn_unit(spawn_location: Vector2):
	var unit_instance = unit.instantiate()
	unit_container.add_child(unit_instance)
	unit_instance.global_position = spawn_location
	unit_instance.connect("died",handle_unit_death)
	
func handle_unit_death():
	if $RespawnTimer.is_stopped() and unit_container.get_children().size() < max_units_alive:
		$RespawnTimer.start()

func _on_respawn_timer_timeout():
	var respawn = respawn_points[next_spawn_to_use]
	spawn_unit(respawn.global_position)
	
	next_spawn_to_use +=1
	if next_spawn_to_use == respawn_points.size():
		next_spawn_to_use = 0
	
	if unit_container.get_children().size() < max_units_alive:
		$RespawnTimer.start()
