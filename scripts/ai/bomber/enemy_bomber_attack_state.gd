class_name EnemyBomberAttackState

extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var ray_cast_player : RayCast2D
@onready var weapon = $"../../Weapon"
@onready var animation_player = $"../../AnimationPlayer"

var player # Reference to the player node

signal lost_player
signal out_of_range

func _ready() -> void:
	set_physics_process(false)
	player = get_node("/root/Game/MainScene/Player")

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("idle")

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	if not actor.alive:
		return
	
	if actor.target:
		# Raycast
		var dir = player.global_position - actor.global_position
		ray_cast_player.target_position.x = actor.attack_range
		ray_cast_player.look_at(actor.global_position + dir)
		
		# Attack when close to player
		var collider
		if ray_cast_player.is_colliding():
			collider = ray_cast_player.get_collider()
		if collider == player:
			animation_player.play("attack")
			actor.alive = false
	
	# Check if enemy tank should change current state to wander
	if not actor.target or ray_cast_player.is_colliding():
		lost_player.emit()
	
	# Check if enemy tank should change current state to chase
	var distance_to_player = actor.global_position.distance_to(player.global_position)
	if (actor.attack_range < distance_to_player):
		out_of_range.emit()
