class_name EnemyTankChaseState

extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var ray_cast_player : RayCast2D

var player # Reference to the player node or position

signal lost_player
signal attack_player

func _ready() -> void:
	set_physics_process(false)
	# Get the player node or position in _ready
	player = get_node("/root/MainScene/Player")

func _enter_state() -> void:
	print("Entered chase state")
	set_physics_process(true)
	animator.play("move")

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	if actor.target:
		# Raycast
		var dir = player.global_position - actor.global_position
		ray_cast_player.look_at(actor.global_position + dir)
		
		# Rotate the enemy tank towards the player's direction
		var current_dir = Vector2(1, 0).rotated(actor.global_rotation)
		actor.rotation = lerp(current_dir, actor.target_dir, actor.rotation_speed * delta).angle()
		
		# Rotate weapon towards the player
		var weapon = get_node("/root/MainScene/EnemyTank/Weapon")
		var current_weapon_dir = Vector2(1, 0).rotated(weapon.global_rotation)
		weapon.global_rotation = lerp(current_weapon_dir, actor.target_dir, actor.turret_speed * delta).angle()
		
		var distance_to_player = actor.global_position.distance_to(player.global_position)
		if (actor.attack_range < distance_to_player):
			# Move the tank forward in the direction it's facing
			actor.velocity = current_dir * actor.max_speed
			actor.move_and_slide()
		else:
			attack_player.emit()

	if not actor.target or ray_cast_player.is_colliding():
		lost_player.emit()
