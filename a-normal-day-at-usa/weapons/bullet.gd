extends Area2D

@export var speed = 675
var team: int= -1
#metodo usado en player.gd
func start(_position, _direction):
	$Sprite2D.show()
	position = _position
	rotation = _direction

func _physics_process(delta):
	#enviamos la posición que tiene que llevar la bala
	global_position += transform.x * speed * delta

func _on_body_entered(body):
	if body.has_method('hitted'):
			body.hitted()
	queue_free()
