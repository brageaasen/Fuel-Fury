extends "res://scripts/abilities/ability.gd"

@export var fuel_increase = 1
@export var iteration_time : float = 0.5

@onready var fuel_timer = $FuelTimer

func _ready():
	_name = "gain_fuel"
	fuel_timer.wait_time = iteration_time

func execute(s):
	if fuel_timer.is_stopped():
		fuel_timer.start()
	s.gain_fuel_no_sound(fuel_increase)

func _on_fuel_timer_timeout():
	execute(get_parent())
