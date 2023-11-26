extends Node2D

class_name Weapon

signal out_of_ammo

var max_ammo : int = 20
var  max_ammo_enemy : int = 15
var current_magazine: int = 0
var current_ammo: int = max_ammo : set = set_current_ammo 
var current_enemy_ammo: int = max_ammo_enemy : set = set_current_enemy_ammo 
@export var bullet_scene: PackedScene 
@onready var pistol_delay = $PistolCooldown
@onready var smg_delay = $SMGCooldown
@onready  var animation_player = $PlayerReload
@onready  var animation_enemy = $EnemyReload
@onready var muzzle = $Muzzle
@onready  var shot_sound = $ShotSound
@onready  var gun = $Gun
var team: int = -1

func _ready():
	pass

func set_current_enemy_ammo(new_ammo:int):
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_enemy_ammo:
		current_enemy_ammo = actual_ammo
		if current_enemy_ammo == 0:
			out_of_ammo.emit()
func start_reload_enemy():
	animation_enemy.play("reload_enemy")

func _stop_reload_enemy():
	current_enemy_ammo = max_ammo

func set_current_ammo(new_ammo: int):
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo == 0:
			out_of_ammo.emit()
		get_parent().get_parent().find_child("GUI").set_current_ammo(current_ammo)

func set_current_magazine(magazine: int):
	current_magazine += magazine

func start_reload():
	if current_magazine != 0:
		current_magazine -= 1
		animation_player.play("reload")
	else:
		return

func _stop_reload():
	current_ammo = max_ammo
	get_parent().get_parent().find_child("GUI").set_current_ammo(current_ammo)



func on_Player_shoot(body: Player):
	global_rotation = body.global_rotation
	#si el tiempo se terminó (cooldown), podemos disparar. Instanciamos dentro la bala.
	if current_ammo != 0  and pistol_delay.is_stopped() and bullet_scene != null:
		var bullet = bullet_scene.instantiate()
		bullet.start((muzzle.global_position), global_rotation)
		get_tree().root.add_child(bullet)
		animation_player.play("muzzle_flash")
		shot_sound.play()
		pistol_delay.start()
		set_current_ammo(current_ammo-1)

func on_shoot():
	#si el tiempo se terminó (cooldown), podemos disparar. Instanciamos dentro la bala.
	if current_enemy_ammo != 0  and pistol_delay.is_stopped() and bullet_scene != null:
		var bullet = bullet_scene.instantiate()
		bullet.start((muzzle.global_position), global_rotation)
		get_tree().root.add_child(bullet)
		animation_player.play("muzzle_flash")
		shot_sound.play()
		pistol_delay.start()
		current_enemy_ammo -= 1
		set_current_enemy_ammo(current_enemy_ammo)
		
func on_smg_shoot():
	#si el tiempo se terminó (cooldown), podemos disparar. Instanciamos dentro la bala.
	if current_enemy_ammo != 0  and smg_delay.is_stopped() and bullet_scene != null:
		var bullet = bullet_scene.instantiate()
		bullet.start((muzzle.global_position), global_rotation)
		get_tree().root.add_child(bullet)
		animation_player.play("muzzle_flash")
		shot_sound.play()
		smg_delay.start()
		current_enemy_ammo -= 1
		set_current_enemy_ammo(current_enemy_ammo)

