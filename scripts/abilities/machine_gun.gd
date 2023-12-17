extends Node

signal ammo_updated # Signal for HUD

var machine_gun_bullet : PackedScene = load( "res://scenes/bullets/machine_gun_bullet.tscn" )

@export var mg_ammo_storage : int = 120

func _ready():
	emit_ammo_update()

func execute(s):
	if Input.is_action_pressed("right_click"):
		if mg_ammo_storage > 0:
			s.shoot(machine_gun_bullet)

func emit_ammo_update():
	ammo_updated.emit(machine_gun_bullet, mg_ammo_storage)
