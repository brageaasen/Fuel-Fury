extends "res://scripts/abilities/ability.gd"

@export var heavy_bullet_recharge_rate = 0.3
@export var machine_gun_bullet_recharge_rate = 0.2

func _ready():
	_name = "faster_ammo_recharge"

func execute(s):
	# Decrease recharge time
	get_parent().get_parent().get_node("Base/AmmoFillTimer").wait_time = heavy_bullet_recharge_rate
	get_parent().get_parent().get_node("Base/MGAmmoFillTimer").wait_time = machine_gun_bullet_recharge_rate
