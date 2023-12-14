class_name EnemyTankWanderState
extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var ray_cast_player : RayCast2D

@onready var enemy_tank = $"../.."

const WANDER_CIRCLE_RADIUS : int = 8
const WANDER_RANDOMNESS : float = 0.2
var wander_angle : float = 0

var obstacle_raycasts = []

var player # Reference to the player node or position

signal found_player

func _ready():
	set_physics_process(false)
	player = get_node("/root/MainScene/Player")
	# Iterate through the children of the RaycastContainer node
	for child in enemy_tank.get_children():
		if child is RayCast2D and child.name.find("ObstacleDetection") != -1:
			obstacle_raycasts.append(child)

func _enter_state() -> void:
	print("Entered wander state")
	set_physics_process(true)
	animator.play("move")
	# If speed is 0 when entering state, start moving
	#if actor.velocity == Vector2.ZERO:
	#	actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed

func _exit_state() -> void:
	set_physics_process(false)


func _physics_process(delta):
	#actor.velocity = actor.velocity.move_toward(actor.velocity.normalized() * actor.max_speed, actor.acceleration * delta)
	#var collision = actor.move_and_collide(actor.velocity * delta)
	#if collision:
	#	var bounce_velocity = actor.velocity.bounce(collision.get_normal())
	#	actor.velocity = bounce_velocity
	var steering = Vector2.ZERO
	steering += wander_steering()
	steering += avoid_obstacles_steering()
	steering = steering.limit_length(actor.max_steering)
	
	actor.velocity += steering
	actor.velocity = actor.velocity.limit_length(actor.max_speed)
	actor.move_and_slide()
	
	if actor.target:
		# Raycast
		var dir = player.global_position - actor.global_position
		ray_cast_player.look_at(actor.global_position + dir)
	
	if actor.target and not ray_cast_player.is_colliding():
		found_player.emit()

func wander_steering() -> Vector2:
	wander_angle = randf_range(wander_angle - WANDER_RANDOMNESS, wander_angle + WANDER_RANDOMNESS)
	var vector_to_circle : Vector2 = actor.velocity.normalized() * actor.max_speed
	var desired_velocity : Vector2 = vector_to_circle + Vector2(WANDER_CIRCLE_RADIUS, 0).rotated(wander_angle)
	return desired_velocity - actor.velocity

func seek_steering() -> Vector2:
	var desired_velocity : Vector2 = (actor.target.position - actor.position).normalized() * actor.max_speed
	return desired_velocity - actor.velocity

func avoid_obstacles_steering() -> Vector2:
	for raycast in obstacle_raycasts:
		raycast.rotation = actor.velocity.angle()
		raycast.target_position.x = actor.velocity.length()
		if raycast.is_colliding():
			var obstacle = raycast.get_collider()
			return (actor.position + actor.velocity - obstacle.position).normalized() * actor.avoid_force
	return Vector2.ZERO
