class_name EnemyTankChaseState

extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var ray_cast_player : RayCast2D

@onready var weapon = $"../../Weapon"

var player # Reference to the player node

signal lost_player
signal attack_player

func _ready() -> void:
	set_physics_process(false)
	player = get_node("/root/Game/MainScene/Player")

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("move")
	print("Entered: CHASE")

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	if actor.target:
		# Raycast
		var dir = player.global_position - actor.global_position
		ray_cast_player.look_at(actor.global_position + dir)
		
		# Rotate weapon towards the player
		var current_weapon_dir = Vector2(1, 0).rotated(weapon.global_rotation)
		weapon.global_rotation = lerp(current_weapon_dir, actor.target_dir, actor.turret_speed * delta).angle()
		
		# Rotate the enemy tank towards the player's direction
		var current_dir = Vector2(1, 0).rotated(actor.global_rotation)
		var angle_diff = current_dir.angle_to(actor.target_dir)
		if abs(angle_diff) > 0.01:
			# Lerp the rotation only when not too aligned to prevent jerky movements
			var new_angle = lerp(current_dir, actor.target_dir, actor.rotation_speed * delta).angle()
			actor.rotation = new_angle
		
		# Only move if the angle of the direction is correct?
		if current_dir.angle_to(actor.target_dir) < 0.01:
			# Move the tank forward in the direction it's facing
			actor.velocity = Vector2(actor.max_speed, 0).rotated(actor.rotation)
			actor.move_and_slide()
		
		# Check if enemy tank should change current state to attack
		var distance_to_player = actor.global_position.distance_to(player.global_position)
		if (actor.attack_range >= distance_to_player):
			attack_player.emit()
	
	# Check if enemy tank should change current state to wander
	if not actor.target or ray_cast_player.is_colliding():
		lost_player.emit()
