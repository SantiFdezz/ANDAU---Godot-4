extends CanvasLayer

@onready var health_bar = $MarginContainer/Rows/BottomRow/HealthSection/HealthBar
@onready var current_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo
@onready var max_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo
@onready var player: Player

var new_health

func set_player(player: Player):
	self.player = player

	set_new_health_value(player.health_stat.status)
	set_current_ammo(player.weapons.current_ammo)
	set_max_ammo(player.weapons.max_ammo)
	player.player_health_changed.connect(set_new_health_value.bind(new_health))
	
func set_new_health_value(new_health):
	print('bien')
	$MarginContainer/Rows/BottomRow/HealthSection/HealthBar.value = new_health
	
func set_current_ammo(new_ammo:int):
	pass
	
func set_max_ammo(new_max_ammo:int):
	pass
