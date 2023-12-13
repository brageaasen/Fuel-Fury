class_name Enemy
extends CharacterBody2D

signal shootSignal
signal health_changed # Keep or remove?
signal dead

@export var health : int
@export var attack_range : float = 60
@export var max_speed = 40.0
@export var acceleration = 50.0
@export var detect_radius : int
@export var max_recoil : float = 10.0
var current_recoil = 0.0
var can_shoot = true
var alive = true
var target = null 



func _ready():
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func shoot(bullet):
	pass

func take_damage(damage):
	health -= damage
	if (health <= 0):
		alive = false
		queue_free() # Destroy object
		emit_signal("dead") # No one catches this signal yet
