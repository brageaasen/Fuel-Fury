extends Node2D

# TODO: Should maybe get target position dynamically from the base object
@export var target_position = Vector2(95, -1) # Current base position
@export var distance_to_activate = 100
var player
var target_alpha = 0

func _ready():
	player = get_node("/root/Game/MainScene/Player")

func _process(_delta):
	if player.position.distance_to(target_position) < distance_to_activate:
		target_alpha = 0
	else:
		target_alpha = 1
	
	rotation = (target_position - player.position).angle() + PI / 2
	position = position.lerp(Vector2(480, 270) + 0.2*Vector2(0, -270).rotated(rotation), 0.1)
	modulate.a = lerp(modulate.a, float(target_alpha), 0.02)
