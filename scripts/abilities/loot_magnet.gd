extends "res://scripts/abilities/ability.gd"

@export var speed = 40
@export var radius : float = 60
@onready var magnet_radius = $MagnetRadius
var inside_radius = []



func _ready():
	_name = "loot_magnet"

func _physics_process(_delta):
	magnet_radius.position = get_parent().global_position
	for area in inside_radius:
		var _direction = (get_parent().global_position - area.global_position).normalized()
		area.velocity = _direction * speed

func execute(_s):
	$MagnetRadius/CollisionShape2D.shape.radius = radius
	$MagnetRadius.area_entered.connect(_on_magnet_radius_area_entered)
	$MagnetRadius.area_exited.connect(_on_magnet_radius_area_exited)

func _on_magnet_radius_area_entered(area):
	if area is Experience or area is Fuel or area is Heart:
		inside_radius.append(area)


func _on_magnet_radius_area_exited(area):
	if area is Experience or area is Fuel or area is Heart:
		inside_radius.erase(area)
