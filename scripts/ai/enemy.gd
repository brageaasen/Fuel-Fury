class_name Enemy
extends CharacterBody2D

signal shootSignal
signal health_changed # Keep or remove?
signal dead

@export var health : int
@export var max_speed = 40.0
@export var acceleration = 50.0
@export var detect_radius : int
@export var max_recoil : float = 10.0
var current_recoil = 0.0
var can_shoot = true
var alive = true
var target = null 

@onready var ray_cast_2d = $RayCast2D
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_wander_state = $FiniteStateMachine/EnemyWanderState as EnemyWanderState
@onready var enemy_chase_state = $FiniteStateMachine/EnemyChaseState as EnemyChaseState

func _ready():
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	# On found_player, wander -> chase
	enemy_wander_state.found_player.connect(fsm.change_state.bind(enemy_chase_state))
	# On lost_player, chase -> wander
	enemy_chase_state.lost_player.connect(fsm.change_state.bind(enemy_wander_state))

func _physics_process(delta):
	ray_cast_2d.target_position = get_local_mouse_position()

func shoot(bullet):
	pass

func take_damage(damage):
	health -= damage
	if (health <= 0):
		alive = false
		queue_free() # Destroy object
		emit_signal("dead") # No one catches this signal yet
