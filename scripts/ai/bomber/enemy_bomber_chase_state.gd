class_name EnemyBomberChaseState
extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var ray_cast_player : RayCast2D

@onready var enemy_bomber = $"../.."
@onready var trail = $"../../Trail/Particles"

var player # Reference to the player node

var obstacle_raycasts = []

const WANDER_CIRCLE_RADIUS : int = 8
const WANDER_RANDOMNESS : float = 0.2
var wander_angle : float = 0

signal attack_player


func _ready() -> void:
	set_physics_process(false)
	player = get_node("/root/Game/MainScene/Player")
	for child in enemy_bomber.get_children():
		if child is RayCast2D and child.name.find("ObstacleDetection") != -1:
			obstacle_raycasts.append(child)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("move")
	trail.emitting = true

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	if actor.target:
		# Raycast
		var dir = player.global_position - actor.global_position
		ray_cast_player.look_at(actor.global_position + dir)
		
		
		# Rotate the enemy bomber towards the player's x direction
		var direction = player.global_position - actor.global_position  # Calculate the direction along the X-axis
		var angle = atan2(direction.x, 1)  # Calculate the angle in radians

		# Convert the angle to degrees and set the rotation of the actor
		actor.rotation_degrees = rad_to_deg(angle)
		
		# Add steering to the velocity of the enemy
		var steering = Vector2.ZERO
		steering += avoid_obstacles_steering()
		steering = steering.limit_length(actor.max_steering)
		
		actor.velocity += steering
		actor.velocity += direction.normalized() * actor.max_speed
		actor.velocity = actor.velocity.limit_length(actor.max_speed)
		
		# Move the bomber forward in the direction towards the player
		actor.move_and_slide()
		
		# Check if enemy tank should change current state to attack
		var distance_to_player = actor.global_position.distance_to(player.global_position)
		if (actor.attack_range >= distance_to_player):
			attack_player.emit()


# Steering Calculation

# Calculate a seek steering
func seek_steering() -> Vector2:
	var desired_velocity : Vector2 = (actor.target.position - actor.position).normalized() * actor.max_speed
	return desired_velocity - actor.velocity

# Calculate steering to avoid obstacles
func avoid_obstacles_steering() -> Vector2:
	var total_avoidance_force = Vector2.ZERO
	for raycast in obstacle_raycasts:
		raycast.global_rotation = actor.velocity.angle()
		if raycast.is_colliding():
			var collision_point = raycast.get_collision_point()
			var collision_normal = raycast.get_collision_normal()
			var distance_to_collision = collision_point.distance_to(actor.global_position)
			var dynamic_avoid_force = actor.avoid_force * (1.0 - distance_to_collision / raycast.target_position.length())
			total_avoidance_force += collision_normal * dynamic_avoid_force
			
	return total_avoidance_force # Removed .normalized()
