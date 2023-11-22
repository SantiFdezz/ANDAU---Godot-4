extends CanvasLayer

@onready var player: Player


func set_player(player: Player):
	self.player = player

	set_new_health_value(player.health_stat.status)
	set_current_ammo(player.weapons.current_ammo)
	set_max_ammo(player.weapons.max_ammo)
	
func set_new_health_value(new_health: int):
	$MarginContainer/Rows/BottomRow/HealthSection/HealthBar.value = new_health	

func set_current_ammo(new_ammo:int):
	$MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo.text = str(new_ammo)
	
func set_max_ammo(new_max_ammo:int):
	$MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo.text = str(new_max_ammo)
