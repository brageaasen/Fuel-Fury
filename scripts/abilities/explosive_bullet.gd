extends "res://scripts/abilities/ability.gd"

@export var new_gun_cooldown = 1
var bullet_path = "res://scenes/bullets/explosive_bullet.tscn"

func _ready():
	_name = "explosive_bullet"

func execute(s):
	# Change the bullet of the player
	s.Bullet = load(bullet_path)
	s.gun_cooldown = new_gun_cooldown
	s.gun_timer.wait_time = new_gun_cooldown
	# Add bullety type to inventory of player
	s.bullet_inventory.append(_name)
