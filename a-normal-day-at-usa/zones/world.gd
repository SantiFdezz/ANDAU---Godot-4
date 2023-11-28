extends Node2D
class_name World

@export var player_died : bool = false : set = set_player_died
@onready var capturable_base_container = $CapturableBaseContainer
@onready var map_ai = $MapAI
@onready var tile_map: TileMap = $Map
@onready var player_respawn = $PlayerRespawnPoint
@onready var enemy_respawn = $EnemyRespawnPoint
@onready var boss_respawn = $BossRespawnPoint
var boss_spawn: bool = false
const Player = preload("res://characters/player/player.tscn")
var roof_layer  = 5
var underground_layer = -5
var faded : bool = false
var darkfade_custom_data = "dark_animation_fade"
var is_paused = false
var player
var player_kills : int = 0
var username: String = ""
var game_over: bool = false

func _ready():
	randomize()
	$BattleMusic.play()
	#desactivamos main screen para que no nos tape la pantalla
	if get_node_or_null(NodePath("/root/Main/MainScreen")):
		get_parent().get_node("/root/Main/MainScreen").visible = false
	var rand_location =  randi() %  player_respawn.get_child_count()
	spawn_player(player_respawn.get_child(rand_location))
	var bases = capturable_base_container.get_capturable_bases()
	map_ai.initialize(bases, enemy_respawn.get_children())

func set_player_died(new_bool: bool):
	player_died = new_bool
func get_player_died():
	return player_died
func _process(_delta):
	var bases = capturable_base_container.get_capturable_bases()
	if player_died == false and bases.size() != 0:
		check_roof()
	elif player_died == true or (player_died == false and bases.size() == 0):
		capturable_base_container.handle_capturable_bases()
	if find_child("MapAI").find_child("BossTimer").is_stopped() and boss_spawn == false:
		boss_spawn = true
		for respawn in boss_respawn.get_children():
			map_ai.spawn_boss(respawn.global_position)
		
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

func set_player_kills():
	self.player_kills+=1

func handle_player_win(username: String, player_bases: int):
	if not game_over:
		game_over = true
		var score = (player_bases+1) * self.player_kills
		send_post_new_score(username, score)
		#get_tree().paused = true
		find_child("GameOver").set_title(true, player_bases)

func handle_player_lost(username: String, player_bases: int):
	if not game_over:
		game_over = true
		var score = ((player_bases+1) * self.player_kills)
		send_post_new_score(username, score)
		#get_tree().paused = true
		find_child("GameOver").set_title(false, player_bases)
	

##API
func send_post_new_score(username: String, score: int):
	if username == null:
		printerr("Will NOT send POST data with score due to invalid username")
		printerr("There might have been an error loading user_data file")
		return
	var body = JSON.stringify({"username": username, "score": score})
	var headers = ["Content-Type: application/json", "Client-Secret: abc"] 
	$HTTPRequest.request("http://127.0.0.1:8000/score", headers, HTTPClient.METHOD_POST, body)

func _on_http_request_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print("Server response:")
	print(response)
