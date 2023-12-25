class_name EnemyTankAttackState

extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var ray_cast_player : RayCast2D
@onready var weapon = $"../../Weapon"

var player # Reference to the player node

signal lost_player
signal out_of_range

func _ready() -> void:
	set_physics_process(false)
	player = get_node("/root/Game/MainScene/Player")

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("idle")
	print("Entered: ATTACK")

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
		
		# Fire when weapon direction is somewhat aligned with the player position, and not colliding
		if actor.target_dir.dot(current_weapon_dir) > 0.9 and not ray_cast_player.is_colliding():
			actor.shoot(actor.Bullet)
	
	# Check if enemy tank should change current state to wander
	if not actor.target or ray_cast_player.is_colliding():
		lost_player.emit()
	
	# Check if enemy tank should change current state to chase
	var distance_to_player = actor.global_position.distance_to(player.global_position)
	if (actor.attack_range < distance_to_player):
		out_of_range.emit()
