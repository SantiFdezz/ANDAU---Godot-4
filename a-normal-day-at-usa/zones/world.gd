extends Node2D
class_name World

signal game_paused(is_paused)

@onready var capturable_base_container = $CapturableBaseContainer
#@export var pause_menu = $PauseMenu
@onready var map_ai = $MapAI
@onready var tile_map: TileMap = $Map
@onready var player_respawn = $PlayerRespawnPoint
@onready var enemy_respawn = $EnemyRespawnPoint
const Player = preload("res://characters/player/player.tscn")
#const PauseScreen = preload("res://menu/pause_menu.tscn") as PackedScene
#const Pause = preload("res://menu/PauseMenu.tscn")
var roof_layer  = 5
var underground_layer = -5
var faded : bool = false
var darkfade_custom_data = "dark_animation_fade"
var is_paused = false
var player
#var player_died :bool = false : set = set_player_died
@export var player_died : bool = false : set = set_player_died
func unpause():
	$GameTimer.start()
	$Pause.hide()

func _ready():
	#Empezamos la musica, el timer de la partida y 
	$GameTimer.start()
	$BattleMusic.play()
	#desactivamos main screen para que no nos tape la vision
	if get_node_or_null(NodePath("/root/Main/MainScreen")):
		get_parent().get_node("/root/Main/MainScreen").visible = false

	randomize()
	var rand_location =  randi() %  player_respawn.get_child_count()
	spawn_player(player_respawn.get_child(rand_location))
	var bases = capturable_base_container.get_capturable_bases()
	#ally_ai.initialize(bases)
	map_ai.initialize(bases, enemy_respawn.get_children())

func set_player_died(new_bool: bool):
	player_died = new_bool
	
func _process(_delta):
	var bases = capturable_base_container.get_capturable_bases()
	if player_died == false and bases.size() != 0:
		check_roof()
	elif player_died == true or bases.size() == 0 or $GameTimer.is_stopped():
		capturable_base_container.handle_capturable_bases()

func spawn_player(location):
	var playerinst = Player.instantiate()
	playerinst.global_position = location.global_position
	add_child(playerinst)
	$GUI.set_player(playerinst)
	self.player = playerinst

func check_roof():
	var p : Vector2 = player.global_position
	var tile_position : Vector2i = tile_map.local_to_map(p)
	var  tile_data : TileData = tile_map.get_cell_tile_data(roof_layer, tile_position)
	if tile_data:
		var tile_to_fade = tile_data.get_custom_data(darkfade_custom_data)
		if tile_to_fade and not faded:
			tile_map.set_layer_z_index(roof_layer, underground_layer)
			faded = true
			$DoorOpening.play()
			$RoofTimer.start()
	elif not tile_data and faded and $RoofTimer.is_stopped():
		tile_map.set_layer_z_index(roof_layer, roof_layer)
		faded = false
		$DoorShutted.play()


func handle_player_win(player_bases):
	get_tree().paused = true
	find_child("GameOver").set_title(true, player_bases)

	
	
func handle_player_lost(player_bases):
	get_tree().paused = true
	find_child("GameOver").set_title(false, player_bases)
