class_name EnemyWanderState
extends State

@export var actor : Enemy
@export var animator : AnimationPlayer
@export var vision_cast : RayCast2D

signal found_player

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("move")
	# If speed is 0 when entering state, start moving
	if actor.velocity == Vector2.ZERO:
		actor.velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * actor.max_speed

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	# Normally one would flip the sprite of the enemy, but we use special
	# movement for enemy
	actor.velocity = actor.velocity.move_toward(actor.velocity.normalized() * actor.max_speed, actor.acceleration * delta)
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		actor.velocity = bounce_velocity
	if not vision_cast.is_colliding():
		found_player.emit()
