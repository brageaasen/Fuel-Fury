extends Node2D

@export var target_position = Vector2(0, 10) # Current base position
@export var ammo_to_activate = 5
@export var distance_from_player = 50
var orbit_radius = 50
var angle = 0

var player
var target_alpha = 0

func _ready():
	player = get_node("/root/Game/MainScene/Player")

func _process(_delta):
	if player.ammo_storage < ammo_to_activate:
		target_alpha = 1
	else:
		target_alpha = 0
	
	# Calculate the position around the target_position based on player's position
	var player_to_target = target_position - player.global_position
	angle = atan2(player_to_target.y, player_to_target.x) + deg_to_rad(90)  # Calculate angle

	# Calculate the position using angle and orbit_radius
	position.x = target_position.x + cos(angle) * orbit_radius
	position.y = target_position.y + sin(angle) * orbit_radius

	# Update visibility alpha
	modulate.a = lerp(modulate.a, float(target_alpha), 0.02)
