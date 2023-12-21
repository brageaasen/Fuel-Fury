extends "res://scripts/abilities/ability.gd"

func _ready():
	_name = "gain_fuel"

func execute(s):
	s.gain_fuel(s.max_fuel)
