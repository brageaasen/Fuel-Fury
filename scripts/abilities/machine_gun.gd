extends "res://scripts/abilities/ability.gd"


var machine_gun_bullet : PackedScene = load( "res://scenes/bullets/machine_gun_bullet.tscn" )

@export var mg_ammo_storage : int = 120

func _ready():
	_name = "machine_gun"

func execute(s):
	if Input.is_action_pressed("right_click"):
		if mg_ammo_storage > 0:
			s.shoot(machine_gun_bullet)
