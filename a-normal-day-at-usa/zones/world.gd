extends Node2D
class_name World

@onready var tile_map: TileMap = $Map
const Player = preload("res://characters/player/player.tscn")
var roof_layer  = 5
var underground_layer = -5
var faded : bool = false
var darkfade_custom_data = "dark_animation_fade"
@onready var player_respawn = $PlayerRespawnPoint
var player

func _ready():
	randomize()
	var rand_location =  randi() %  player_respawn.get_child_count()
	spawn_player(player_respawn.get_child(rand_location))

func spawn_player(location):
	var playerinst = Player.instantiate()
	playerinst.global_position = location.global_position
	add_child(playerinst)
	get_parent().get_node("GUI").set_player(playerinst)
	self.player = playerinst
	
func _process(_delta):
	if player != null:
		set_roof()
	
func set_roof():
	var p : Vector2 = player.global_position
	var tile_position : Vector2i = tile_map.local_to_map(p)
	var  tile_data : TileData = tile_map.get_cell_tile_data(roof_layer, tile_position)
	if tile_data:
		var tile_to_fade = tile_data.get_custom_data(darkfade_custom_data)
		if tile_to_fade and not faded:
			tile_map.set_layer_z_index(roof_layer, underground_layer)
			faded = true
			$DoorOpening.play()
	elif not tile_data and faded:
		tile_map.set_layer_z_index(roof_layer, roof_layer)
		faded = false
		$DoorShutted.play()