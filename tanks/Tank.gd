extends CharacterBody2D

signal health_changed
signal dead

@export var Bullet: PackedScene
@export var speed: int
@export var rotation_speed: float
@export var gun_cooldown: float
@export var health: int

var can_shoot = true
var alive = true

func _ready():
	$GunTimer.wait_time = gun_cooldown
	
func control(delta):
	pass

func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_slide()
