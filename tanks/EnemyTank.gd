extends "res://tanks/Tank.gd"

@export var turret_speed : float
@export var detect_radius : int

var target = null

func _ready():
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		$Weapon.global_rotation = lerp(current_dir, target_dir, turret_speed * delta).angle()

func _on_detect_radius_body_entered(body):
	if body.name == "Player":
		target = body

func _on_detect_radius_body_exited(body):
	if body == target:
		target = null
