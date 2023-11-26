extends CPUParticles2D
var emmiting

func _ready():
	get_direction_to()
	emmiting = true

func get_direction_to():
	direction.x = 1

func _on_timer_timeout():
	queue_free()
