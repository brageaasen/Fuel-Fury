class_name EnemyTankChaseState

extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var vision_cast : RayCast2D

var player # Reference to the player node or position

signal lost_player

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
		# Rotate the enemy tank towards the player's direction
		var current_dir = Vector2(1, 0).rotated(actor.global_rotation)
		actor.rotation = lerp(current_dir, actor.target_dir, actor.rotation_speed * delta).angle()
		
		var dir = player.global_position - actor.global_position
		vision_cast.look_at(actor.global_position + dir)
		
		# Move the tank forward in the direction it's facing
		#actor.velocity = target_direction * actor.max_speed
		#actor.move_and_slide()

	if not actor.target or vision_cast.is_colliding():
		lost_player.emit()
