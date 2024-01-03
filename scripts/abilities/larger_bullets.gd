extends "res://scripts/abilities/ability.gd"

@export var scale_multiplier = 2
@export var damage_multiplier = 2

func _ready():
	_name = "larger_bullets"

func execute(s):
	# Increase the size and damage of player bullet
	s.bullet_scale_multiplier = scale_multiplier
	s.bullet_damage_multiplier = damage_multiplier
