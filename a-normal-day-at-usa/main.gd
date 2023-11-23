extends Node2D

@onready var gui = $GUI
@onready var game_over = $GameOver
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func handle_player_win():
	var game_over_inst = game_over.instantiate()
	add_child(game_over_inst)
	game_over_inst.set_title(true)
	get_tree().paused = true
	
	
func handle_player_lost():
	var game_over_inst = game_over.instantiate()
	add_child(game_over_inst)
	game_over_inst.set_title(false)
	get_tree().paused = true
	
