extends "res://scripts/abilities/ability.gd"

@export var max_speed_increase = 30

func _ready():
	_name = "more_speed"

func execute(s):
	# Increase health pool size
	s.max_speed += max_speed_increase
