class_name Enemy
extends CharacterBody2D

signal shootSignal
signal health_changed
signal died

@export var score_value : int
@export var max_health : int
@export var experience_drop : PackedScene
# Movement
@export var max_speed = 40.0
@export var acceleration = 50.0
var max_steering : float = 2.5
var avoid_force : int = 50
# Combat
@export var attack_range : float = 60
@export var detect_radius : int
@export var max_recoil : float = 10.0
var current_recoil = 0.0
var can_shoot = true
var alive = true
var target = null 

var bullet_scale_multiplier = 1
var bullet_damage_multiplier = 1

var health : int


func _ready():
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func shoot(bullet):
	pass

func take_damage(damage):
	health -= damage
	emit_signal("health_changed", health * 100/max_health)
	if (health <= 0):
		die() # Destroy object

func die():
	pass
