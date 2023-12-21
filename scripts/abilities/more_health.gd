extends "res://scripts/abilities/ability.gd"

@export var max_health_increase = 100

func _ready():
	_name = "more_health"

func execute(s):
	# Increase health pool size
	s.max_health += max_health_increase
	# Update max health of progressbar
	# To emit health changed
	s.gain_health(0)
