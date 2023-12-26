extends "res://scripts/abilities/ability.gd"

func _ready():
	_name = "fire_projectile"

func execute(s):
	# Change the bullet of the player
	s.Bullet = load("res://scenes/bullets/fire_bullet.tscn")
