extends Node2D

class_name Weapon

signal out_of_ammo

var max_ammo : int = 20
var current_ammo: int = max_ammo : set = set_current_ammo 
var current_enemy_ammo: int = max_ammo : set = set_current_enemy_ammo 
@export var bullet_scene: PackedScene 
@onready var shot_delay = $ShotCooldown
@onready  var animation_player = $AnimationPlayer
@onready var muzzle = $Muzzle
@onready  var shot_sound = $ShotSound
@onready  var gun = $Gun
@onready var player : CharacterBody2D = $"/root/Main/World/Player"
var team: int = -1
var body
func _ready():
	pass

func initialize(team: int):
	self.team = team

func set_current_enemy_ammo(new_ammo:int):
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo == 0:
			out_of_ammo.emit()

func set_current_ammo(new_ammo: int):
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo == 0:
			out_of_ammo.emit()
		get_node("/root/Main/GUI").set_current_ammo(current_ammo)

func start_reload():
	animation_player.play("reload")

func _stop_reload():
	current_ammo = max_ammo
	get_node("/root/Main/GUI").set_current_ammo(current_ammo)

func on_Player_shoot():
	global_rotation = player.global_rotation
	#si el tiempo se terminó (cooldown), podemos disparar. Instanciamos dentro la bala.
	if current_ammo != 0  and shot_delay.is_stopped() and bullet_scene != null:
		var bullet = bullet_scene.instantiate()
		bullet.start((muzzle.global_position), global_rotation)
		get_tree().root.add_child(bullet)
		animation_player.play("muzzle_flash")
		shot_sound.play()
		shot_delay.start()
		set_current_ammo(current_ammo-1)

func on_shoot():
	#si el tiempo se terminó (cooldown), podemos disparar. Instanciamos dentro la bala.
	if current_ammo != 0  and shot_delay.is_stopped() and bullet_scene != null:
		var bullet = bullet_scene.instantiate()
		bullet.start((muzzle.global_position), global_rotation)
		get_tree().root.add_child(bullet)
		animation_player.play("muzzle_flash")
		shot_sound.play()
		shot_delay.start()
		set_current_enemy_ammo(current_ammo)

