extends "res://scripts/abilities/ability.gd"

@export var max_speed_increase = 30
@export var max_health_increase = 100
@export var rotation_speed_increase = 0.5

var upgrade_particles = preload("res://scenes/particles/player_upgrade.tscn")

func _ready():
	_name = "secret_ability"

func execute(s):
	# Play upgrade particles
	var p = upgrade_particles.instantiate()
	s.get_parent().add_child(p)
	p.global_position = s.global_position
	
	# Increase sprite scale of player
	s.scale = Vector2(1.5, 1.5)
	# Increase max_speed and rotation_speed
	s.max_speed += max_speed_increase
	s.rotation_speed += rotation_speed_increase
	# Increase health pool size
	s.increase_max_health(s.max_health + max_health_increase)
	s.gain_health(max_health_increase)
	# Add new weapon to tanks
	s.get_node("Weapon2").visible = true
