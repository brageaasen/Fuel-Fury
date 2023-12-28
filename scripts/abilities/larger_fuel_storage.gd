extends "res://scripts/abilities/ability.gd"

@export var max_fuel_increase = 100

var upgrade_particles = preload("res://scenes/particles/base_upgrade.tscn")

var texture_over = preload("res://assets/sprites/base2_case.png")
var texture_progress = preload("res://assets/sprites/base2_progress.png")

func _ready():
	_name = "larger_fuel_storage"

func execute(s):
	# Increase storage size
	s.max_fuel += max_fuel_increase
	# Play particle animation
	var p = upgrade_particles.instantiate()
	get_parent().get_parent().add_child(p)
	p.global_position = get_parent().get_parent().get_node("Base/FuelContainer").position
	# TODO: Slowly scale instead of changing sprite?
	# Change sprite of storage
	get_parent().get_parent().get_node("Base/FuelContainer/FuelBar").texture_over = texture_over
	get_parent().get_parent().get_node("Base/FuelContainer/FuelBar").texture_progress = texture_progress
