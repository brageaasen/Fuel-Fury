extends "res://scripts/abilities/ability.gd"

@export var max_health_increase = 100

func _ready():
	_name = "more_health"

func execute(s):
	# Increase health pool size
	s.max_health += max_health_increase
	s.gain_health(s.max_health)
