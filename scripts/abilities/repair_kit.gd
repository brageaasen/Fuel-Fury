extends "res://scripts/abilities/ability.gd"

@export var health_increase = 1
@export var iteration_time = 1

@onready var health_timer = $HealthTimer

func _ready():
	_name = "repair_kit"
	health_timer.wait_time = iteration_time

func execute(s):
	if health_timer.is_stopped():
		health_timer.start()
	s.gain_health(health_increase)

func _on_health_timer_timeout():
	execute(get_parent())
