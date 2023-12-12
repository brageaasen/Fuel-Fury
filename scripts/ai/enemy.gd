class_name Enemy
extends CharacterBody2D

signal shootSignal
signal health_changed # Keep or remove?
signal dead

@export var health : int
@export var max_speed = 40.0
@export var acceleration = 50.0
@export var detect_radius : int
@onready var ray_cast_2d = $RayCast2D

@export var max_recoil : float = 10.0
var current_recoil = 0.0
var can_shoot = true
var alive = true
var target = null 

func _ready():
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius

func _physics_process(delta):
	ray_cast_2d.target_position = get_local_mouse_position()
