extends "res://scripts/abilities/ability.gd"

@export var speed = 4
@export var radius : float = 30.0
var inside_radius = []



func _ready():
	_name = "loot_magnet"
	$MagnetRadius/CollisionShape2D.shape.radius = radius

func _physics_process(delta):
	for area in inside_radius:
		var _direction = (area.global_position - get_parent().global_position).normalized()
		area.velocity = _direction * speed

func execute(s):
	pass

func _on_magnet_radius_area_entered(area):
	if area is Experience or area is Fuel:
		inside_radius.append(area)


func _on_magnet_radius_area_exited(area):
	if area is Experience or area is Fuel:
		inside_radius.erase(area)
