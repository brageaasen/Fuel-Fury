extends "res://scripts/abilities/ability.gd"

@export var max_speed_increase = 30
@export var rotation_speed_increase = 0.5

func _ready():
	_name = "more_speed"

func execute(s):
	# Increase max_speed and rotation_speed
	s.max_speed += max_speed_increase
	s.rotation_speed += rotation_speed_increase
