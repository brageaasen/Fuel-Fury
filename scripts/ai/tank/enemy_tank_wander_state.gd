class_name EnemyTankWanderState
extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var ray_cast_player : RayCast2D
var obstacle_raycasts = []

@onready var enemy_tank = $"../.."
@onready var body = $"../../Body"
@onready var weapon = $"../../Weapon"

const WANDER_CIRCLE_RADIUS : int = 8
const WANDER_RANDOMNESS : float = 0.2
var wander_angle : float = 0

var player # Reference to the player node

signal found_player


func _ready():
	set_physics_process(false)
	player = get_node("/root/Game/MainScene/Player")
	# Iterate through the children of the RaycastContainer node
	for child in enemy_tank.get_children():
		if child is RayCast2D and child.name.find("ObstacleDetection") != -1:
			obstacle_raycasts.append(child)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("move")

func _exit_state() -> void:
	set_physics_process(false)


func _physics_process(delta):
	# Rotate weapon forward
	var current_weapon_dir = Vector2(1, 0).rotated(weapon.global_rotation)
	var current_dir = Vector2(1, 0).rotated(actor.global_rotation)
	weapon.global_rotation = lerp(current_weapon_dir, current_dir, actor.turret_speed * delta).angle()
	
	# Add steering to the velocity of the enemy
	var steering = Vector2.ZERO
	steering += wander_steering()
	steering += avoid_obstacles_steering()
	steering = steering.limit_length(actor.max_steering)
	
	actor.velocity += steering
	actor.velocity = actor.velocity.limit_length(actor.max_speed)
	actor.move_and_slide()
	
	# Rotate the enemy tank body
	actor.rotation = actor.velocity.angle()
	
	# Emit found player and change states if player is found
	if actor.target:
		# Raycast
		var dir = player.global_position - actor.global_position
		ray_cast_player.look_at(actor.global_position + dir)
		var collider
		if ray_cast_player.is_colliding():
			collider = ray_cast_player.get_collider()
		if collider == player:
			found_player.emit()
			collider = null

# Calculate a random wander steering
func wander_steering() -> Vector2:
	wander_angle = randf_range(wander_angle - WANDER_RANDOMNESS, wander_angle + WANDER_RANDOMNESS)
	var vector_to_circle : Vector2 = actor.velocity.normalized() * actor.max_speed
	var desired_velocity : Vector2 = vector_to_circle + Vector2(WANDER_CIRCLE_RADIUS, 0).rotated(wander_angle)
	return desired_velocity - actor.velocity

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
