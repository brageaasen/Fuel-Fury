class_name EnemyChaseState
extends State

@export var actor : Enemy
@export var animator : AnimatedSprite2D
@export var vision_cast : RayCast2D

signal lost_player

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("move")

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta) -> void:
	# Normally one would flip the sprite of the enemy, but we use special
	# movement for enemy
	
	# Temp direction
	var direction = Vector2.ZERO.direction_to(actor.get_local_mouse_position())
	actor.velocity = actor.velocity.move_toward(direction * actor.max_speed, actor.acceleration * delta)
	actor.move_and_slide()
	if vision_cast.is_colliding():
		lost_player.emit()
