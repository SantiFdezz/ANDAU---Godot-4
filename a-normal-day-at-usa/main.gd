extends Node2D

const Player = preload("res://characters/player/player.tscn")
@onready var capturable_base_container = $CapturableBaseContainer
@onready var map_ai = $MapAI
@onready var gui = $GUI
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	var enemy_respawn = $EnemyRespawnPoint
	
	var bases = capturable_base_container.get_capturable_bases()

	#ally_ai.initialize(bases)
	map_ai.initialize(bases, enemy_respawn.get_children())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

