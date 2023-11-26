extends Node2D

@onready var world: Node2D = $World
@onready var mainscreen: CanvasLayer = $MainScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

