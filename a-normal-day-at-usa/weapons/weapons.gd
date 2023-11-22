extends Node2D

class_name Weapon

signal out_of_ammo()

var max_ammo : int = 20
var current_ammo: int = max_ammo

@export var bullet_scene: PackedScene 
@onready var shot_delay = $ShotCooldown
@onready  var animation_player = $AnimationPlayer
@onready var muzzle = $Muzzle
@onready  var shot_sound = $ShotSound
@onready  var gun = $Gun
@onready var player : CharacterBody2D = $"/root/Main/World/Player"
var team: int = -1

func _ready():
	pass

func initialize(team: int):
	self.team = team
	
func on_Player_shoot():
	global_rotation = player.global_rotation
	on_shoot()

func on_shoot():
	#si el tiempo se terminó (cooldown), podemos disparar. Instanciamos dentro la bala.
	if current_ammo != 0  and shot_delay.is_stopped() and bullet_scene != null:
		var bullet = bullet_scene.instantiate()
		bullet.start(muzzle.global_position, global_rotation)
		get_tree().root.add_child(bullet)
		animation_player.play("muzzle_flash")
		shot_sound.play()
		shot_delay.start()
		current_ammo -=1
		if current_ammo == 0:
			out_of_ammo.emit()
		pass
		

func start_reload():
	animation_player.play("reload")
func _stop_reload():
	current_ammo = max_ammo

